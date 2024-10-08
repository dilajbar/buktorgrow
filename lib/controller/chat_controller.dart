import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/messages_model.dart';

class ChatController extends GetxController {
  var isAttachmentVisible = false.obs;
  var messages = <Message>[].obs;
  var isMicPressed = false.obs;
  var isMiccancel = false.obs;

  void setMicPressed(bool value) {
    isMicPressed.value = value;
  }

  void toggleAttachmentVisibility() {
    isAttachmentVisible.value = !isAttachmentVisible.value;
  }

  void sendMessage(String text) {
    final now = DateTime.now();
    final formattedTime = DateFormat('hh:mm a').format(now);
    messages
        .add(Message(text: text, isSentByMe: true, timestamp: formattedTime));
    Future.delayed(const Duration(seconds: 1), () {
      messages.add(Message(
          text: "Okay 👍", isSentByMe: false, timestamp: formattedTime));
    });
  }

  void sendAttachment(String fileName, IconData icon,
      {XFile? attachmentData}) async {
    final now = DateTime.now();
    final formattedTime = DateFormat('hh:mm a').format(now);

    Uint8List? bytes;

    if (attachmentData != null) {
      if (icon == Icons.mic) {
        // For voice notes, we'll just store the file path
        bytes = Uint8List.fromList(attachmentData.path.codeUnits);
      } else {
        // For other attachments, read the bytes
        bytes = await attachmentData.readAsBytes();
      }
    }

    messages.add(Message(
      text: fileName,
      isSentByMe: true,
      isAttachment: true,
      attachmentIcon: icon,
      timestamp: formattedTime,
      attachmentData: bytes,
    ));

    // Simulate received message after a delay
    Future.delayed(const Duration(seconds: 1), () {
      final now = DateTime.now();
      final formattedTime = DateFormat('hh:mm a').format(now);
      messages.add(Message(
        text: "Okay 👍",
        isSentByMe: false,
        timestamp: formattedTime,
      ));
    });
  }
}
