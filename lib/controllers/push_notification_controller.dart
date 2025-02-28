import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:poker/controllers/controller.dart';

class PushNotificationController {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  triggerNotification({required String? title, required String? body}) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: title,
      body: body,
    ));
  }

  Future initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    getToken();
    await _fcm.requestPermission();
    await _fcm.subscribeToTopic('all');

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        ///display notification
        triggerNotification(
            title: message.notification!.title,
            body: message.notification!.body);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      ///display notification
      triggerNotification(
          title: message.notification!.title, body: message.notification!.body);
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    ///display notification
    triggerNotification(
        title: message.notification!.title, body: message.notification!.body);
  }

  Future<String?> getToken() async {
    String? token = await _fcm.getToken();
    mainController.token.value = token ?? '';
    mainController.lua();
    return token;
  }
}
