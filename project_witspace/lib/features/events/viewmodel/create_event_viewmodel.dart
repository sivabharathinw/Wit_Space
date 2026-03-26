import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/event_model.dart';
import '../data/repository/event_repository.dart';

final createEventViewModelProvider = StateNotifierProvider<CreateEventViewModel, AsyncValue<void>>((ref) {
  final repository = ref.watch(eventRepositoryProvider);
  return CreateEventViewModel(repository);
});

class CreateEventViewModel extends StateNotifier<AsyncValue<void>> {
  final EventRepository _repository;

  CreateEventViewModel(this._repository) : super(const AsyncValue.data(null));

    state = const AsyncValue.loading();
    final event = EventModel((b) => b
      ..id = ''
      ..title = title
      ..description = description
      ..location = location
      ..date = date
      ..time = time
      ..imageUrl = imageUrl
      ..createdByUserId = 'mockUser123'
      ..createdAt = DateTime.now()
    );
    
    await _repository.createEvent(event);
    state = const AsyncValue.data(null);
  }
}
