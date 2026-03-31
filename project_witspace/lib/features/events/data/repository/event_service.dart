import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../model/event_model.dart';
import '../model/registration_model.dart';
import '../model/notification_model.dart';

class EventService {
  final FirebaseFirestore _firestore;
  //it is provided by fcm(firebase cloud message) to send notification
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  //localnotification is used to send noti from the app without server like fcm
  //so need flutterlocalnotfication plugin
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  EventService(this._firestore);

  // initialize notification service
  Future<void> init() async {
  //to  get permission from the user to allow notifications
    await _requestPermission();
    //set up the local notifications

    await _initLocalNotification();

  }

  Future<void> _requestPermission() async {
    //requestPermission() is a method from the fcm to get req from the user
    await _messaging.requestPermission();
  }

//this method initialize the local notifications
  Future<void> _initLocalNotification() async {
    //@mipmap/ic_launcher  is the icon for the notifications it  is located on the and/app/src/main/res/
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    //IntilizetionSetings holds settings for all platforms andr,ios
    const initSettings = InitializationSettings(android: androidSettings);
    //initizialize the local notification with android settings to show the notifications
    await _localNotifications.initialize(settings: initSettings);

//creating the notification channel this controls the notifications behaviour
    const channel = AndroidNotificationChannel(
      //1st arg is channel_id unique id used by the system to indetify the channel
      'channel_id',
      //channel name it is visible to user
      'channel_name',
      description: 'Used for event push notifications',
      //importance represent how imp teh notificatiosn are
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
    );
    await _localNotifications
//to get the platform specific implementation of the flutter local notifications plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    //create the noti channel
        ?.createNotificationChannel(channel);
  }


  //this mtd define how the noti behaves on android
  Future<void> showLocalNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    //localnotification.show() actualluy shows the noti which needs an notification details obj which has android details
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
        // add default values for missing fields
        data['createdBy'] = data['createdBy'] ?? 'Unknown';
        data['createdAt'] = data['createdAt'] ?? DateTime.now();
        final rawImageUrl = data['imageUrl'] as String? ?? '';
        data['imageUrl'] = (rawImageUrl.startsWith('http') && rawImageUrl.length > 10) ? rawImageUrl : '';
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
      // Add default values for missing fields
      data['createdBy'] = data['createdBy'] ?? 'Unknown';
      data['createdAt'] = data['createdAt'] ?? DateTime.now();
      final rawImageUrl = data['imageUrl'] as String? ?? '';
      data['imageUrl'] = (rawImageUrl.startsWith('http') && rawImageUrl.length > 10) ? rawImageUrl : '';
      data['time'] = data['time'] ?? '00:00';

      return EventModel.fromJson(data)!;
    });
  }

  // create event
  Future<void> createEvent(EventModel event) async {
    final data = event.toJson();
    data.remove('id');
    await _firestore.collection('events').add(data);
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
  Future<RegistrationModel?> getUserRegistrationForEvent(String eventId, String userId) async {
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
