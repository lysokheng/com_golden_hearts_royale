import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:get/get.dart';
import 'package:poker/controllers/controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    gameController;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        Image.asset(
          'assets/images/bg.png',
          fit: BoxFit.fill,
          width: width,
          height: height,
        ),
        Positioned(
            top: height * 0.05,
            child: Image.asset(
              'assets/images/logo.png',
              width: Get.width * 0.3,
            )),
        Positioned(
            bottom: height * 0.275,
            child: GestureDetector(
                onTap: () {
                  if (gameController.isSound.value) {
                    FlameAudio.play('tap.mp3');
                  }
                  Get.toNamed('/game');
                },
                child: Image.asset(
                  'assets/images/Vector Smart Object-1.png',
                  height: height * 0.2,
                ))),
        Positioned(
            bottom: height * 0.05,
            child: GestureDetector(
                onTap: () {
                  if (gameController.isSound.value) {
                    FlameAudio.play('tap.mp3');
                  }
                  FlutterExitApp.exitApp();
                },
                child: Image.asset(
                  'assets/images/Vector Smart Object.png',
                  height: height * 0.2,
                )))
      ]),
    );
  }
}
