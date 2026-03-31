import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../model/event_model.dart';
import '../model/registration_model.dart';
import '../model/notification_model.dart';

class EventService {
  final FirebaseFirestore _firestore;
  // FCM to send notifications
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  EventService(this._firestore);

  // Initialize notification service
  Future<void> init() async {
    // Request permission from user
    await _requestPermission();
    // Listen for FCM messages
    _listenFCM();
    await saveDeviceToken('temp_user_id');
  }
  Future<void> saveDeviceToken(String userId) async {
    String? token = await _messaging.getToken();

    if (token != null) {
      await _firestore.collection('users').doc(userId).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission();
  }

  void _listenFCM() {
    // Listen to messages when the app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title;
      final body = message.notification?.body;
      if (title != null && body != null) {

        print('FCM Notification received - Title: $title, Body: $body');
      }
    });
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