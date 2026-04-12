import 'package:project_witspace/features/events/data/model/notification_model.dart';
import '../../features/events/data/model/notification_model.dart';
import '../../features/events/data/model/event_model.dart';
import '../../features/events/data/model/registration_model.dart';
abstract class EventServiceAbstract{
  Future<void> init();
  Future<void> saveDeviceToken(String userId);
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  });
  //events
  Stream<List<EventModel>> getEventsStream();
  Stream<EventModel> getEventStream(String eventId);
  Future<void> createEvent(EventModel event);
  Future<void> updateEvent(EventModel event);
  Future<void> deleteEvent(String eventId);
  // registrations
  Future<String> registerForEvent(RegistrationModel registration);
  Future<RegistrationModel?> getUserRegistrationForEvent(
      String eventId,
      String userId,
      );
  Stream<List<RegistrationModel>> getUserRegistrationsStream(String userId);
  // notifications
  Stream<List<NotificationModel>> getNotificationsStream(String userId);
  Future<void> addNotification({
    required String senderId,
    required String receiverId,
    required String title,
    required String message,
  });
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> deleteNotification(String notificationId);
  Future<void> deleteAllNotifications(String userId);
  Future<void> updateNotification(String notificationId);
}