import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/model/event_model.dart';
import '../data/model/registration_model.dart';
import '../data/model/notification_model.dart';
import '../data/model/event_state.dart';
import '../data/repository/event_service.dart';

final eventNotifierProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  final repository = EventService(FirebaseFirestore.instance);
  return EventNotifier(repository);
});


class EventNotifier extends StateNotifier<EventState> {
  final EventService _repository;
  StreamSubscription? _eventsSubscription;
  StreamSubscription? _notificationsSubscription;
  String? _currentUserId;

  EventNotifier(this._repository) : super(EventState.initial()) {
    _init();
  }

  void _init() {
    _loadEvents();
    setUserId('temp_user_id');
  }

  void _loadEvents() {
    _eventsSubscription?.cancel();
    _eventsSubscription = _repository.getEventsStream().listen((events) {
      _updateState(events: events);
    });
  }

  void setUserId(String userId) {
    if (_currentUserId == userId) return;
    _currentUserId = userId;
    _loadNotifications();
  }

  void _loadNotifications() {
    if (_currentUserId == null) return;
    
    _notificationsSubscription?.cancel();
    _notificationsSubscription = _repository.getNotificationsStream(_currentUserId!).listen(
      (notifications) {
        _updateState(notifications: notifications);
      },
      onError: (error) {
        _updateState(error: error.toString());
      },
    );
  }

  void _updateState({
    List<EventModel>? events,
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? error,
    String? registrationId,
  }) {
    state = state.rebuild((b) {
      if (events != null) b.events = ListBuilder(events);
      if (notifications != null) b.notifications = ListBuilder(notifications);
      if (isLoading != null) b.isLoading = isLoading;
      if (error != null) b.error = error;
      if (registrationId != null) b.registrationId = registrationId;
    });
  }

  Future<void> createEvent(EventModel event) async {
    _updateState(isLoading: true, error: null);
    try {
      await _repository.createEvent(event);
      if (_currentUserId != null) {
        await _repository.addNotification(
          senderId: 'system',
          receiverId: _currentUserId!,
          title: 'New Event Created',
          message: 'Your event "${event.title}" has been successfully created.',
        );
      }
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
      if (_currentUserId != null) {
        await _repository.addNotification(
          senderId: 'system',
          receiverId: _currentUserId!,
          title: 'Registration Successful',
          message: 'You have been registered for the event.',
        );
      }
      _updateState(isLoading: false, registrationId: id);
    } catch (e) {
      _updateState(isLoading: false, error: e.toString());
    }
  }

  void resetStatus() {
    _updateState(isLoading: false, error: null, registrationId: null);
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _repository.markAsRead(notificationId);
    } catch (e) {
      _updateState(error: e.toString());
    }
  }

  Future<void> markAllAsRead() async {
    if (_currentUserId == null) return;
    try {
      await _repository.markAllAsRead(_currentUserId!);
    } catch (e) {
      _updateState(error: e.toString());
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _repository.deleteNotification(notificationId);
    } catch (e) {
      _updateState(error: e.toString());
    }
  }

  Future<void> updateNotification(NotificationModel notification) async {
    try {
      await _repository.updateNotification(notification);
    } catch (e) {
      _updateState(error: e.toString());
    }
  }

  Future<void> deleteAllNotifications() async {
    if (_currentUserId == null) return;
    try {
      await _repository.deleteAllNotifications(_currentUserId!);
    } catch (e) {
      _updateState(error: e.toString());
    }
  }

  @override
  void dispose() {
    _eventsSubscription?.cancel();
    _notificationsSubscription?.cancel();
    super.dispose();
  }
}
