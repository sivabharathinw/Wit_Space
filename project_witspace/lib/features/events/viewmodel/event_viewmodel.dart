import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/model/event_model.dart';
import '../data/model/registration_model.dart';
import '../data/model/notification_model.dart';
import '../data/model/event_state.dart';
import '../data/service/event_service_impl.dart';

final eventServiceProvider = Provider<EventService>((ref) {
  return EventService(FirebaseFirestore.instance);
});

final eventNotifierProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  final repository = ref.watch(eventServiceProvider);
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
    _repository.init(); // call the inti method in service  to set up the notification
    _loadEvents();
    setUserId('temp_user_id');
  }

  void _loadEvents() {
    //if eventsub is not null cancel it.means if already listening to events then cancel it.
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
    bool? isRegistered,
  }) {
    state = state.rebuild((b) {
      if (events != null) b.events = ListBuilder(events);
      if (notifications != null) b.notifications = ListBuilder(notifications);
      if (isLoading != null) b.isLoading = isLoading;
      if (error != null) b.error = error;
      if (registrationId != null) b.registrationId = registrationId;
      if (isRegistered != null) b.isRegistered = isRegistered;
    });
  }

  Future<void> createEvent(EventModel event) async {
    _updateState(isLoading: true, error: null);
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
  }

  Future<void> updateEvent(EventModel event) async {
    _updateState(isLoading: true, error: null);
    await _repository.updateEvent(event);
    _updateState(isLoading: false);
  }

  Future<void> deleteEvent(String eventId) async {
    _updateState(isLoading: true, error: null);
    await _repository.deleteEvent(eventId);
    _updateState(isLoading: false);
  }

  Future<void> register(RegistrationModel registration) async {
    _updateState(isLoading: true, error: null, registrationId: null);
    final id = await _repository.registerForEvent(registration);//this method returns the registration id
    if (_currentUserId != null) {
      await _repository.addNotification(
        senderId: 'system',
        receiverId: _currentUserId!,
        title: 'Registration Successful',
        message: 'You have been registered for the event.',
      );
    }
    _updateState(isLoading: false, registrationId: id, isRegistered: true);
  }

  Future<void> checkRegistrationStatus(String eventId) async {
    if (_currentUserId == null) return;
    _updateState(isRegistered: false); // Reset before checking
    final registration = await _repository.getUserRegistrationForEvent(eventId, _currentUserId!);
    //if user registerd already it returns the registration else null
//with this we upadate teh isregisterd is tru or fls
    _updateState(isRegistered: registration != null);
  }
//void resetStatus is used to reset the isregistered to false
  void resetStatus() {
    _updateState(isLoading: false, error: null, registrationId: null);
  }

  Future<void> markAsRead(String notificationId) async {
    await _repository.markAsRead(notificationId);
  }

  Future<void> markAllAsRead() async {
    if (_currentUserId == null) return;
    await _repository.markAllAsRead(_currentUserId!);
  }

  Future<void> deleteNotification(String notificationId) async {
    await _repository.deleteNotification(notificationId);
  }

  Future<void> updateNotification(NotificationModel notification) async {
    await _repository.updateNotification(notification.id);
  }

  Future<void> deleteAllNotifications() async {
    if (_currentUserId == null) return;
    await _repository.deleteAllNotifications(_currentUserId!);
  }

  @override
  void dispose() {
    _eventsSubscription?.cancel();
    _notificationsSubscription?.cancel();
    super.dispose();
  }
}
