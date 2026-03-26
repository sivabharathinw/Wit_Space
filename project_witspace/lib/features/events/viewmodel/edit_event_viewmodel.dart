import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/event_model.dart';
import '../data/repository/event_repository.dart';

final editEventViewModelProvider = StateNotifierProvider<EditEventViewModel, AsyncValue<void>>((ref) {
  final repository = ref.watch(eventRepositoryProvider);
  return EditEventViewModel(repository);
});

class EditEventViewModel extends StateNotifier<AsyncValue<void>> {
  final EventRepository _repository;

  EditEventViewModel(this._repository) : super(const AsyncValue.data(null));

  Future<void> updateEvent({
    required EventModel originalEvent,
    required String title,
    required String description,
    required String location,
    required DateTime date,
    required TimeOfDay time,
    required String imageUrl,
  }) async {
    state = const AsyncValue.loading();
    final updatedEvent = originalEvent.rebuild((b) => b
      ..title = title
      ..description = description
      ..location = location
      ..date = date
      ..time = time
      ..imageUrl = imageUrl
    );

    await _repository.updateEvent(updatedEvent);
    state = const AsyncValue.data(null);
  }
}
