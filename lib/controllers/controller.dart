import 'package:get/get.dart';
import 'package:poker/controllers/game_controller.dart';
import 'package:poker/controllers/main_controller.dart';
import 'package:poker/controllers/push_notification_controller.dart';

GameController gameController = Get.put(GameController());
PushNotificationController pushNotificationController =
    PushNotificationController();
MainController mainController = Get.put(MainController());
