import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:built_collection/built_collection.dart';
import '../data/model/event_model.dart';
import '../data/model/registration_model.dart';
import '../data/model/notification_model.dart';
import '../data/model/event_state.dart';
import '../data/repository/event_repository.dart';
import '../data/factory/notification_factory.dart';

//create provider and notifier for single app it have 2 types notifier contains logic to handle the data and state have all the data

final eventNotifierProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
    final repository = EventRepository();
    return EventNotifier(repository);
  });
class EventNotifier extends StateNotifier<EventState> {
  final EventRepository _repository;
  StreamSubscription? _eventsSubscription;
  StreamSubscription? _notificationsSubscription;
  String? _currentUserId;

  EventNotifier(this._repository) : super(EventState.initial()) {
    _init();
  }

  Future<void> _init() async {
    await _repository.firestoreService.init();
    _loadEvents();
    setUserId('temp_user_id');
  }

  void _loadEvents() {
    //if eventsub is not null cancel it.means if already listening to events then cancel it.
    _eventsSubscription?.cancel();
    //listen to  events stream and upadate when state  is  chng
    _eventsSubscription = _repository.firestoreService.getEventsStream().listen((events) {

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
    _notificationsSubscription = _repository.firestoreService.getNotificationsStream(_currentUserId!).listen(
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
   await _repository.firestoreService.createEvent(event);
    if (_currentUserId != null) {
      final notification = NotificationFactory.create(
        type: NotificationType.eventCreated,
        receiverId: _currentUserId!,
        data: {'eventTitle': event.title},
      );
      await _repository.firestoreService.addNotification(
        senderId: notification.senderId,
        receiverId: notification.receiverId,
        title: notification.title,
        message: notification.message,
      );
    }
    _updateState(isLoading: false);
  }

  Future<void> updateEvent(EventModel event) async {
    _updateState(isLoading: true, error: null);
    await _repository.firestoreService.updateEvent(event);
    _updateState(isLoading: false);
  }

  Future<void> deleteEvent(String eventId) async {
    _updateState(isLoading: true, error: null);
    await _repository.firestoreService.deleteEvent(eventId);
    _updateState(isLoading: false);
  }

  Future<void> register(RegistrationModel registration) async {
    _updateState(isLoading: true, error: null, registrationId: null);
    await _repository.firestoreService.registerForEvent(registration);
    if (_currentUserId != null) {
      final notification = NotificationFactory.create(
        type: NotificationType.registrationSuccessful,
        receiverId: _currentUserId!,
        data: {},
      );

      await _repository.firestoreService.addNotification(
        senderId: notification.senderId,
        receiverId: notification.receiverId,
        title: notification.title,
        message: notification.message,
      );
    }
    _updateState(isLoading: false, registrationId: registration.id, isRegistered: true);
  }

  Future<void> checkRegistrationStatus(String eventId) async {
    if (_currentUserId == null) return;
    _updateState(isRegistered: false); // Reset before checking
    final registration = await _repository.firestoreService.getUserRegistrationForEvent(eventId, _currentUserId!);
    //if user registerd already it returns the registration else null
    //with this we upadate teh isregisterd is tru or fls
    _updateState(isRegistered: registration != null);
  }
//void resetStatus is used to reset the isregistered to false
  void resetStatus() {
    _updateState(isLoading: false, error: null, registrationId: null);
  }

  Future<void> markAsRead(String notificationId) async {
    await _repository.firestoreService.markAsRead(notificationId);
  }

  Future<void> markAllAsRead() async {
    if (_currentUserId == null) return;
    await _repository.firestoreService.markAllAsRead(_currentUserId!);
  }

  Future<void> deleteNotification(String notificationId) async {
    await _repository.firestoreService.deleteNotification(notificationId);
  }

  Future<void> updateNotification(NotificationModel notification) async {
    await _repository.firestoreService.updateNotification(notification.id);
  }

  Future<void> deleteAllNotifications() async {
    if (_currentUserId == null) return;
    await _repository.firestoreService.deleteAllNotifications(_currentUserId!);
  }

  @override
  void dispose(){
    _eventsSubscription?.cancel();
    _notificationsSubscription?.cancel();
    super.dispose();
  }
}
