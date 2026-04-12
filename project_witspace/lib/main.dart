import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'router/app_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//if the app is closed and the noti comes this function will run
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
 //getInitialMessage is  from fcm it check if the app opened by tapping the noti it returns if yes it gives rem mess or null
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print('Terminated state initial message: ${initialMessage.messageId}');
    final route = initialMessage.data['route'] as String?;
    if (route != null) {

      Future.delayed(const Duration(milliseconds: 500), () {
        appRouter.push(route);
      });
    }
  }
//ths handles when app is runnning on background and user tap on noti
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Background state message tap: ${message.messageId}');
    final route = message.data['route'] as String?;
    if (route != null) {
      appRouter.push(route);
    }
  });
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Events App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF007A7C)),
        //usematerial3 is treu means use the ltst version of material desighn
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
