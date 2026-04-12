import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:flutter/services.dart' show rootBundle;
import 'notification_strategy.dart';

class FcmNotificationStrategy implements NotificationStrategy {
  final List<String> fcmTokens;

  FcmNotificationStrategy(this.fcmTokens);

  @override
  Future<void> notify({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    if (fcmTokens.isEmpty) return;

    try {
      const String projectId = 'wit-space';
      final String endpoint = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
      final String accessToken = await _getAccessToken();

      for (String token in fcmTokens) {
        await http.post(
          Uri.parse(endpoint),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(
            <String, dynamic>{
              'message': <String, dynamic>{
                'token': token,
                'notification': <String, dynamic>{
                  'title': title,
                  'body': body,
                },
                'data': data ?? {},
                'android': <String, dynamic>{
                  'notification': <String, dynamic>{
                    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  },
                },
              },
            },
          ),
        );
      }
    } catch (e) {
      print('FCM Strategy Error: $e');
    }
  }

  Future<String> _getAccessToken() async {
    final jsonString = await rootBundle.loadString('assets/service_account.json');
    final accountCredentials = auth.ServiceAccountCredentials.fromJson(jsonString);
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = await auth.clientViaServiceAccount(accountCredentials, scopes);
    final accessToken = client.credentials.accessToken.data;
    client.close();
    return accessToken;
  }
}
