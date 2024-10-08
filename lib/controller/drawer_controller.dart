import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Drawercontroller extends GetxController {
  var selectedIndex = 1.obs;

  void selectItem(int index) {
    selectedIndex.value = index;
  }

  Future<void> launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (uri.scheme != 'https') {
        throw 'URL is not secure: $url';
      }
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri,
            mode: LaunchMode.inAppWebView,
            webViewConfiguration:
                const WebViewConfiguration(enableJavaScript: true));
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}
