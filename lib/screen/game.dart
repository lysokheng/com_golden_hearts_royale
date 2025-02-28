import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:poker/controllers/controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Game extends StatefulWidget {
  const Game({super.key});
  @override
  State<Game> createState() => _GameState();
}

String convert({required String key}) {
  return utf8.decode(base64.decode(key));
}

class _GameState extends State<Game> {
  final GlobalKey key = GlobalKey();
  WebViewController webViewController = WebViewController();
  bool isLoading = true;

  void getWebViewController() {
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(mainController.url.value))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      );
  }

  @override
  void initState() {
    // Set preferred orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    getWebViewController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.center,
          children: [
            WebViewWidget(
              controller: webViewController,
            ),
            if (isLoading) ...[
              Positioned(
                  child: Container(
                width: Get.width,
                height: Get.height,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
              )),
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.yellow,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
