import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_strategy.dart';
import 'dart:convert';

class LocalNotificationStrategy implements NotificationStrategy {
  final FlutterLocalNotificationsPlugin localNotifications;
  LocalNotificationStrategy(this.localNotifications);

  @override
  Future<void> notify({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await localNotifications.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: data != null ? jsonEncode(data) : null,
    );

  }
}
