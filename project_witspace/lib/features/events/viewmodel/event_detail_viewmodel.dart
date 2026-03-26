import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/event_model.dart';
import '../data/repository/event_repository.dart';

final eventDetailProvider = StreamProvider.family<EventModel, String>((ref, eventId) {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getEventStream(eventId);
});

final eventDetailViewModelProvider = Provider<EventDetailViewModel>((ref) {
  return EventDetailViewModel(ref.watch(eventRepositoryProvider));
});

class EventDetailViewModel {
  final EventRepository _repository;

  EventDetailViewModel(this._repository);

  Future<void> deleteEvent(String eventId) async {
    await _repository.deleteEvent(eventId);
  }
}
