import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/event_model.dart';
import '../data/repository/event_repository.dart';

final eventListViewModelProvider = StreamProvider<List<EventModel>>((ref) {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getEventsStream();
});
