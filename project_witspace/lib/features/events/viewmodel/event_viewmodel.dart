import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/model/event_model.dart';
import '../data/model/registration_model.dart';
import '../data/model/event_state.dart';
import '../data/repository/event_service.dart';

final eventNotifierProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  final repository = EventService(FirebaseFirestore.instance);
  return EventNotifier(repository);
});


class EventNotifier extends StateNotifier<EventState> {
  final EventService _repository;
  StreamSubscription? _eventsSubscription;

  EventNotifier(this._repository) : super(EventState.initial()) {
    _init();
  }

  void _init() {
    _loadEvents();
  }

  void _loadEvents() {
    _eventsSubscription?.cancel();
    _eventsSubscription = _repository.getEventsStream().listen((events) {
      _updateState(events: events);
    });
  }

  void _updateState({
    List<EventModel>? events,
    bool? isLoading,
    String? error,
    String? registrationId,
  }) {
    state = state.rebuild((b) {
      if (events != null) b.events = ListBuilder(events);
      if (isLoading != null) b.isLoading = isLoading;
      if (error != null) b.error = error;
      if (registrationId != null) b.registrationId = registrationId;
    });
  }



  Future<void> createEvent(EventModel event) async {
    _updateState(isLoading: true, error: null);
    try {
      await _repository.createEvent(event);
      _updateState(isLoading: false);
    } catch (e) {
      _updateState(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateEvent(EventModel event) async {
    _updateState(isLoading: true, error: null);
    try {
      await _repository.updateEvent(event);
      _updateState(isLoading: false);
    } catch (e) {
      _updateState(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteEvent(String eventId) async {
    _updateState(isLoading: true, error: null);
    try {
      await _repository.deleteEvent(eventId);
      _updateState(isLoading: false);
    } catch (e) {
      _updateState(isLoading: false, error: e.toString());
    }
  }

  Future<void> register(RegistrationModel registration) async {
    _updateState(isLoading: true, error: null, registrationId: null);
    try {
      final id = await _repository.registerForEvent(registration);
      _updateState(isLoading: false, registrationId: id);
    } catch (e) {
      _updateState(isLoading: false, error: e.toString());
    }
  }

  void resetStatus() {
    _updateState(isLoading: false, error: null, registrationId: null);
  }

  @override
  void dispose() {
    _eventsSubscription?.cancel();
    super.dispose();
  }
}
