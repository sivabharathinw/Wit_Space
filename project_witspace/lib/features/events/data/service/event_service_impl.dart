import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../model/event_model.dart';
import '../model/registration_model.dart';
import '../model/notification_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project_witspace/core/service/event_service.dart';
import '../strategy/fcm_strategy.dart';
import '../strategy/local_strategy.dart';
import 'package:project_witspace/router/app_router.dart';

class EventService implements EventServiceAbstract {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  EventService();
  //_eventsRef  returns the eventmodel coll
  CollectionReference<EventModel> get _eventsRef=>
  //connects to firestore  events
      _firestore.collection('events').withConverter<EventModel>(

        fromFirestore: (snapshot, _) {
          final data = snapshot.data()!;
          data['id'] = snapshot.id;
          data['createdBy'] = data['createdBy'] ?? 'Unknown';
          data['createdAt'] = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          final rawImageUrl = data['imageUrl'] as String? ?? '';
          data['imageUrl'] =
          (rawImageUrl.startsWith('http') && rawImageUrl.length > 10)
              ? rawImageUrl
              : '';
          data['time'] = data['time'] ?? '00:00';
          return EventModel.fromJson(data)!;
        },
        toFirestore: (event, _) => event.toJson(),
      );

  CollectionReference<Map<String, dynamic>> get _usersCollection => _firestore.collection('users');

  CollectionReference<NotificationModel> get _notificationsRef =>
      _firestore.collection('notifications').withConverter<NotificationModel>(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data()!;
          data['id'] = snapshot.id;
          data['createdAt'] = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          return NotificationModel.fromJson(data)!;
        },
        toFirestore: (notification, _) => notification.toJson(),
      );


  CollectionReference<RegistrationModel> _registrationsRef(String eventId) =>
      _firestore.collection('events').doc(eventId).collection('registrations').withConverter<RegistrationModel>(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data()!;
          data['id'] = snapshot.id;
          data['registeredAt'] = (data['registeredAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          return RegistrationModel.fromJson(data)!;
        },
        toFirestore: (registration, _) => registration.toJson(),
      );

  // initialize notification service
  Future<void> init() async {
    await saveDeviceToken('temp_user_id');
    await _requestPermission();
    await _initLocalNotification();
    _listenFCM();
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission();
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  void _listenFCM() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title;
      final body = message.notification?.body;
      if (title != null && body != null) {
        print('FCM Notification received - Title: $title, Body: $body');
        final payload = jsonEncode(message.data);
        showLocalNotification(title: title, body: body, payload: payload);
      }
    });
  }
  Future<void> saveDeviceToken(String userId) async {
    final token = await _messaging.getToken();
    if (token != null) {
      await _usersCollection.doc(userId).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }
  }
  Future<void> _initLocalNotification() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          final data = jsonDecode(payload) as Map<String, dynamic>;
          final route = data['route'] as String?;
          if (route != null) {
            appRouter.push(route);
          }
        }
      },
    );

    const channel = AndroidNotificationChannel(
      'channel_id',
      'channel_name',
      description: 'Used for event push notifications',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> showLocalNotification({required String title, required String body, String? payload}) async {
    final strategy = LocalNotificationStrategy(_localNotifications);
    await strategy.notify(
      title: title,
      body: body,
      data: payload != null ? jsonDecode(payload) : null,
    );
  }

  // read all events
  Stream<List<EventModel>> getEventsStream() {
    //eventsRef is a collection ref to event
    return _eventsRef
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // read single event 
  Stream<EventModel> getEventStream(String eventId) {
    return _eventsRef.doc(eventId).snapshots().map((doc) {
      if (!doc.exists) throw Exception('Event not found');
      return doc.data()!;
    });
  }

  Future<void> createEvent(EventModel event) async {
    final docRef = await _eventsRef.add(event);
    await docRef.update({'id': docRef.id});
    await _sendPushNotificationToAllUsers(
      title: 'New Event: ${event.title}',
      body: 'A new event has been created! Join us.',
      eventId: docRef.id,
    );
  }

  Future<void> _sendPushNotificationToAllUsers({required String title, required String body, String? eventId}) async {
    try {
      final snapshot = await _usersCollection.where('fcmToken', isNotEqualTo: null).get();
      final tokens = snapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['fcmToken'] as String?)
          .where((t) => t != null && t!.isNotEmpty)
          .cast<String>()
          .toList();

      if (tokens.isEmpty) return;

      final strategy = FcmNotificationStrategy(tokens);
      await strategy.notify(
        title: title,
        body: body,
        data: {
          'route': eventId != null ? '/events/$eventId' : '/events',
        },
      );
    } catch (e) {
      print('Error sending push notification via strategy: $e');
    }
  }

  Future<void> updateEvent(EventModel event) async {
    await _eventsRef.doc(event.id).set(event, SetOptions(merge: true));
  }

  // delete event
  Future<void> deleteEvent(String eventId) async {
    await _eventsRef.doc(eventId).delete();
  }

  // register for event
  Future<String> registerForEvent(RegistrationModel registration) async {
    final docRef = _registrationsRef(registration.eventId).doc();
    final updatedRegistration = registration.rebuild((b) => b..id = docRef.id);
    await docRef.set(updatedRegistration);
    return docRef.id;
  }

  // check if user is registered for an event
  Future<RegistrationModel?> getUserRegistrationForEvent(
      String eventId, String userId) async {
    final snapshot = await _registrationsRef(eventId)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }

  // get user registrations stream
  Stream<List<RegistrationModel>> getUserRegistrationsStream(String userId) {
    return _firestore
        .collectionGroup('registrations')
        .withConverter<RegistrationModel>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data()!;
            data['id'] = snapshot.id;
            data['registeredAt'] = (data['registeredAt'] as Timestamp?)?.toDate() ?? DateTime.now();
            return RegistrationModel.fromJson(data)!;
          },
          toFirestore: (registration, _) => registration.toJson(),
        )
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // get notifications stream
  Stream<List<NotificationModel>> getNotificationsStream(String userId) {
    return _notificationsRef
        .where('receiverId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> markAsRead(String notificationId) async {
    await _notificationsRef.doc(notificationId).update({
      'hasSeen': true,
    });
  }

  Future<void> markAllAsRead(String userId) async {
    final snapshot = await _notificationsRef
        .where('receiverId', isEqualTo: userId)
        .where('hasSeen', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'hasSeen': true});
    }
    await batch.commit();
  }

  Future<void> deleteNotification(String notificationId) async {
    await _notificationsRef.doc(notificationId).delete();
  }

  Future<void> updateNotification(String notificationId) async {
    await _notificationsRef.doc(notificationId).update({
      'hasSeen': true,
    });
  }

  Future<void> deleteAllNotifications(String userId) async {
    final snapshot = await _notificationsRef
        .where('receiverId', isEqualTo: userId)
        .get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
  Future<void> addNotification({
    required String senderId,
    required String receiverId,
    required String title,
    required String message,
  }) async {
    final docRef = _notificationsRef.doc();
    final notification = NotificationModel((b) => b
      ..id = docRef.id
      ..senderId = senderId
      ..receiverId = receiverId
      ..title = title
      ..message = message
      ..createdAt = DateTime.now()
      ..hasSeen = false
    );
    await docRef.set(notification);
  }
}