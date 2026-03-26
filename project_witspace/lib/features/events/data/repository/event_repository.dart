import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/event_model.dart';
import '../model/registration_model.dart';
import '../model/serializers.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository(FirebaseFirestore.instance);
});

class EventRepository {
  final FirebaseFirestore _firestore;

  EventRepository(this._firestore);

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
        final event = serializers.deserializeWith(EventModel.serializer, data);
        return event;
      }).where((e) => e != null).cast<EventModel>().toList();
    });
  }

  // Read single event
  Stream<EventModel> getEventStream(String eventId) {
    return _firestore.collection('events').doc(eventId).snapshots().map((doc) {
      if (!doc.exists) throw Exception('Event not found');
      final data = doc.data()!;
      data['id'] = doc.id;
      return serializers.deserializeWith(EventModel.serializer, data)!;
    });
  }

  // Create event
  Future<void> createEvent(EventModel event) async {
    final data = serializers.serializeWith(EventModel.serializer, event) as Map<String, dynamic>;
    data.remove('id'); // Firestore auto-generates doc ID or we use a separate doc ID logic
    await _firestore.collection('events').add(data);
  }

  // Update event
  Future<void> updateEvent(EventModel event) async {
    final data = serializers.serializeWith(EventModel.serializer, event) as Map<String, dynamic>;
    data.remove('id');
    await _firestore.collection('events').doc(event.id).update(data);
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }

  // Register for event
  Future<String> registerForEvent(RegistrationModel registration) async {
    final data = serializers.serializeWith(RegistrationModel.serializer, registration) as Map<String, dynamic>;
    data.remove('id');
    final docRef = await _firestore
        .collection('events')
        .doc(registration.eventId)
        .collection('registrations')
        .add(data);
    return docRef.id;
  }
}
