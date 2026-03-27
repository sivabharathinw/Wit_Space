import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/event_model.dart';
import '../model/registration_model.dart';
import '../model/serializers.dart';


class EventService {
  final FirebaseFirestore _firestore;

  EventService(this._firestore);

  // Read all events
  Stream<List<EventModel>> getEventsStream() {
    return _firestore
        .collection('events')
        .orderBy('date')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        // Add default values for missing fields
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
}

