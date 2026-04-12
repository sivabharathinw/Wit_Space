abstract class NotificationStrategy {
  Future<void> notify({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  });
}


