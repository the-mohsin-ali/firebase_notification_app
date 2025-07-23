import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notification_app/firebase_options.dart';
import 'package:firebase_notification_app/home_screen.dart';
import 'package:firebase_notification_app/notifications_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  final NotificationsService notificationsService = NotificationsService();
  notificationsService.initLocalNotifications();
  notificationsService.requestNotificationPermissions();
  notificationsService.isTokenRefresh();
  runApp(MyApp(notificationsService: notificationsService));
}

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    print(message.notification!.title.toString());
    print('Background message received: ${message.notification!.body}');
  }
  
}

class MyApp extends StatelessWidget {
  final NotificationsService notificationsService;
  const MyApp({super.key, required this.notificationsService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(notificationsService: notificationsService),
    );
  }
}
