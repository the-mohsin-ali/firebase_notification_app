import 'package:firebase_notification_app/notifications_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  final NotificationsService notificationsService;

  const HomeScreen(
      {super.key, required this.notificationsService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationsService notificationsService = NotificationsService();

  @override
  void initState() {
    super.initState();
    widget.notificationsService.requestNotificationPermissions();
    widget.notificationsService.isTokenRefresh();
    widget.notificationsService.firebaseInit(context);

    notificationsService.getToken().then((token) {
      if (kDebugMode) {
        print("Firebase Messaging Token: $token");
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Error getting token: $error");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.deepPurple),
        title: const Text(
          'Firebase Notifications',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text('Notifications Service Initialized'),
      ),
    );
  }
}
