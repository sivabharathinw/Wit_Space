import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/event_model.dart';
import '../model/registration_model.dart';
import '../model/notification_model.dart';
import '../model/serializers.dart';


class EventService {
  final FirebaseFirestore _firestore;

  EventService(this._firestore);

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

        try {
          return EventModel.fromJson(data);
        } catch (e) {
          print('Error deserializing event: $e');
          return null;
        }
      }).where((e) => e != null).cast<EventModel>().toList();
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

  // Create event
  Future<void> createEvent(EventModel event) async {
    final data = event.toJson();
    data.remove('id');
    await _firestore.collection('events').add(data);
  }

  // Update event
  Future<void> updateEvent(EventModel event) async {
    final data = event.toJson();
    data.remove('id');
    await _firestore.collection('events').doc(event.id).update(data);
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }

  // Register for event
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


  Stream<List<RegistrationModel>> getUserRegistrationsStream(String userId) {
    return _firestore
        .collectionGroup('registrations')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        try {
          return RegistrationModel.fromJson(data);
        } catch (e) {
          return null;
        }
      }).where((r) => r != null).cast<RegistrationModel>().toList();
    });
  }



  Stream<List<NotificationModel>> getNotificationsStream(String userId) {
    return _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        
        if (data['createdAt'] is Timestamp) {
          data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
        }

        try {
          return NotificationModel.fromJson(data);
        } catch (e) {
          print('Error deserializing notification: $e');
          return null;
        }
      }).where((n) => n != null).cast<NotificationModel>().toList();
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
    final data = notification.toJson();
    data.remove('id');
    await _firestore.collection('notifications').doc(notification.id).update(data);
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
