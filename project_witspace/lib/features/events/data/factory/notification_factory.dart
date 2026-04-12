import '../model/notification_model.dart';

enum NotificationType {
  eventCreated,
  registrationSuccessful,
}

class NotificationFactory {
  static NotificationModel create({
    required NotificationType type,
    required String receiverId,
    required Map<String, dynamic> data,
  }) {
    final docId = '';

    switch (type) {
      case NotificationType.eventCreated:
        final eventTitle = data['eventTitle'] ?? 'New Event';
        return NotificationModel((b) => b
          ..id = docId
          ..senderId = 'system'
          ..receiverId = receiverId
          ..title = 'New Event Created'
          ..message = 'Your event "$eventTitle" has been successfully created.'
          ..createdAt = DateTime.now()
          ..hasSeen = false
        );
        
      case NotificationType.registrationSuccessful:
        return NotificationModel((b) => b
          ..id = docId
          ..senderId = 'system'
          ..receiverId = receiverId
          ..title = 'Registration Successful'
          ..message = 'You have been registered for the event.'
          ..createdAt = DateTime.now()
          ..hasSeen = false
        );
    }
  }
}
