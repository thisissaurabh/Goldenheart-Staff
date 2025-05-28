// ignore_for_file: must_be_immutable

import 'package:astrowaypartner/controllers/Authentication/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PageScreen extends StatelessWidget {
  final String linkType;

  PageScreen({super.key, required this.linkType});

  final LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    // Fetch the page link here
    loginController.fetchPagesLink(linkType);

    // Initialize WebViewController here
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            const CircularProgressIndicator();
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Terms condition error- > $error');
          },
        ),
      )
      ..loadRequest(Uri.parse(loginController.pagesLink));

    return SafeArea(
      child: Scaffold(
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
