import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notification_app/message_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotifications(
      // BuildContext context,
      //  RemoteMessage message
      ) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('ic_notification');
    var initailizationSetting =
        InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initailizationSetting,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (kDebugMode) {
        print('Notification tapped: ${response.payload}');
      }
    });
  }

  void requestNotificationPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
        print(message.data['type'].toString());
        print(message.data['id'].toString());

        print("🔔 onMessage (Foreground) payload:");
        print("Notification: ${message.notification}");
        print("Data: ${message.data}");
      }

      showNotifications(message);
      handleMessage(context, message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published! ${message.data}');
        print("📲 onMessageOpenedApp (Tapped from background):");
        print("Notification: ${message.notification}");
        print("Data: ${message.data}");
      }
      handleMessage(context, message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        if (kDebugMode) {
          print(
              'A new onMessageOpenedApp event was published! ${message.data}');
          print("📲 getInitialMessage (Tapped from terminated state):");
          print("Notification: ${message.notification}");
          print("Data: ${message.data}");
        }
        handleMessage(context, message);
      }
    });
  }

  Future<void> showNotifications(RemoteMessage message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
        'high_importance_channel', 'High Importance Channel',
        description: 'This channel is used for important notifications',
        importance: Importance.max,
        playSound: false);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'This is a high importance channel',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    // DarwinNotificationDetails darwinNotificationDetails =
    //     const DarwinNotificationDetails(
    //   presentAlert: true,
    //   presentBadge: true,
    //   presentSound: true,
    // );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      //  iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero, () async {
      await flutterLocalNotificationsPlugin.show(
        0,
        'New Message',
        message.notification?.title ??
            message.data['title'] ??
            message.data['screen'] ??
            'Notification',
        message.notification?.body ??
            message.data['text'] ??
            'You have a new message',

        // payload: message.data.toString(),
      );
    });
  }

  Future<String> getToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((newToken) {
      newToken.toString();
      if (kDebugMode) {
        print("New Token: $newToken");
      }
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    final id = message.data['id'];
    final screen = message.data['screen'];

    if (screen == 'message') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MessageScreen(),
          ));
    }
  }
}
