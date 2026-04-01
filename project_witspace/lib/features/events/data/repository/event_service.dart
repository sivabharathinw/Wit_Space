import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../model/event_model.dart';
import '../model/registration_model.dart';
import '../model/notification_model.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class EventService {
  final FirebaseFirestore _firestore;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  EventService(this._firestore);

  // Initialize notification service
  Future<void> init() async {
    // Request permission from user
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
        showLocalNotification(title, body);
      }
    });
  }

  Future<void> saveDeviceToken(String userId) async {
    final token = await _messaging.getToken();
    if (token != null) {
      await _firestore.collection('users').doc(userId).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }
  }

  Future<void> _initLocalNotification() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(settings: initSettings);

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

  Future<void> showLocalNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await _localNotifications.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

  // read all events
  Stream<List<EventModel>> getEventsStream() {
    return _firestore
        .collection('events')
        .orderBy('date')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        data['createdBy'] = data['createdBy'] ?? 'Unknown';
        data['createdAt'] = data['createdAt'] ?? DateTime.now();
        final rawImageUrl = data['imageUrl'] as String? ?? '';
        data['imageUrl'] =
        (rawImageUrl.startsWith('http') && rawImageUrl.length > 10)
            ? rawImageUrl
            : '';
        data['time'] = data['time'] ?? '00:00';
        return EventModel.fromJson(data);
      }).whereType<EventModel>().toList();
    });
  }

  // Read single event
  Stream<EventModel> getEventStream(String eventId) {
    return _firestore.collection('events').doc(eventId).snapshots().map((doc) {
      if (!doc.exists) throw Exception('Event not found');
      final data = doc.data()!;
      data['id'] = doc.id;
      data['createdBy'] = data['createdBy'] ?? 'Unknown';
      data['createdAt'] = data['createdAt'] ?? DateTime.now();
      final rawImageUrl = data['imageUrl'] as String? ?? '';
      data['imageUrl'] =
      (rawImageUrl.startsWith('http') && rawImageUrl.length > 10)
          ? rawImageUrl
          : '';
      data['time'] = data['time'] ?? '00:00';
      return EventModel.fromJson(data)!;
    });
  }

  // create event
  Future<void> createEvent(EventModel event) async {
    final data = event.toJson();
    data.remove('id');
    await _firestore.collection('events').add(data);
    await _sendPushNotificationToAllUsers('New Event: ${event.title}', 'A new event has been created! Join us.');
  }
//this is the method to get access token  from service account
  //service account is used by app to talk with the services liek firebase
  Future<String> _getAccessToken() async {
    // read the service account json file from assets
    final jsonString = await rootBundle.loadString(
        'assets/service_account.json');
    //store the acc credentials as a object  from the json file
    final accountCredentials = auth.ServiceAccountCredentials.fromJson(
        jsonString);
//scope is  a permission  ask by the app to accesses the google fcm to send notrification bcxz the event creation notification is done by app so itself is a sender too.so send notification to fcm needs to ask permisiion to google
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    //this uses a service account and  permission to get authenticate by google
    final client = await auth.clientViaServiceAccount(
        accountCredentials, scopes);

    final accessToken = client.credentials.accessToken.data;
    client.close();
    return accessToken;
  }
  //this method send notification from my app to fcm so only it get permission
  Future<void> _sendPushNotificationToAllUsers(String title, String body) async {
    try {
      //extract all users from the firestore
      final snapshot = await _firestore.collection('users').where('fcmToken', isNotEqualTo: null).get();
      final tokens = snapshot.docs
          .map((doc) => doc.data()['fcmToken'] as String?)
          .where((t) => t != null && t.isNotEmpty)
          .cast<String>()
          .toList();

      if (tokens.isEmpty) return;

      // Project ID from firebase.json
      const String projectId = 'wit-space';
      //this is the endpoint(url or address) where we send notification req
      final String endpoint = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
      //to send notification we need access token
      final String accessToken = await _getAccessToken();
//itearete through each device tokem
      for (String token in tokens) {
        //http.post() send data to endpoint
        await http.post(
          Uri.parse(endpoint),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          //this th actual message to send to fcm
          body: jsonEncode(
            <String, dynamic>{
              'message': <String, dynamic>{
                'token': token,
                'notification': <String, dynamic>{
                  'title': title,
                  'body': body,
                },
                //android specific
                'android': <String, dynamic>{
                  'notification': <String, dynamic>{
                    //when clcik the noti it opens the app
                    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  }
                }
              },
            },
          ),
        );
      }
    } catch (e) {
      print('Error sending push notification (HTTP v1): $e');
    }
  }

  // update event
  Future<void> updateEvent(EventModel event) async {
    final data = event.toJson();
    data.remove('id');
    await _firestore.collection('events').doc(event.id).update(data);
  }

  // delete event
  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }

  // register for event
  Future<String> registerForEvent(RegistrationModel registration) async {
    final data = registration.toJson();
    data.remove('id');
    final docRef = await _firestore
        .collection('events')
        .doc(registration.eventId)
        .collection('registrations')
        .add(data);
    return docRef.id;
  }

  // check if user is registered for an event
  Future<RegistrationModel?> getUserRegistrationForEvent(
      String eventId, String userId) async {
    final snapshot = await _firestore
        .collection('events')
        .doc(eventId)
        .collection('registrations')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    final data = doc.data();
    data['id'] = doc.id;
    return RegistrationModel.fromJson(data);
  }

  // get user registrations stream
  Stream<List<RegistrationModel>> getUserRegistrationsStream(String userId) {
    return _firestore
        .collectionGroup('registrations')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return RegistrationModel.fromJson(data);
      }).whereType<RegistrationModel>().toList();
    });
  }

  // get notifications stream
  Stream<List<NotificationModel>> getNotificationsStream(String userId) {
    return _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        data['createdAt'] = data['createdAt'] ?? DateTime.now();
        return NotificationModel.fromJson(data);
      }).whereType<NotificationModel>().toList();
    });
  }

  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'hasSeen': true,
    });
  }

  Future<void> markAllAsRead(String userId) async {
    final snapshot = await _firestore
        .collection('notifications')
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
    await _firestore.collection('notifications').doc(notificationId).delete();
  }

  Future<void> updateNotification(NotificationModel notification) async {
    await _firestore.collection('notifications').doc(notification.id).update({
      'hasSeen': true,
    });
  }

  Future<void> deleteAllNotifications(String userId) async {
    final snapshot = await _firestore
        .collection('notifications')
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
    await _firestore.collection('notifications').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'title': title,
      'message': message,
      'hasSeen': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}