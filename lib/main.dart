import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poker/controllers/controller.dart';
import 'package:poker/firebase_options.dart';
import 'package:poker/screen/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).whenComplete(() {
    ///FirebaseMessaging
    pushNotificationController.initialize();
  });

  // Initialize Awesome Notifications
  AwesomeNotifications().initialize(
    'resource://mipmap-xxhdpi/ic_launcher.png', // Ensure this icon is added to your project
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
      ),
    ],
    debug: true,
  );

  // Request notification permissions
  AwesomeNotifications().requestPermissionToSendNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            fontFamily: 'Blues'),
        getPages: [
          GetPage(
              name: '/',
              page: () => Center(child: const CircularProgressIndicator())),
          GetPage(name: '/game', page: () => const GameScreen()),
        ]);
  }
}
