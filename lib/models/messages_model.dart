import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Message model representing a chat message.
class Message {
  final String text;
  final bool isSentByMe;
  final bool isAttachment;
  final IconData? attachmentIcon;
  final String timestamp;
  Uint8List? attachmentData; // New field for attachment data

  Message({
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
    this.isAttachment = false,
    this.attachmentIcon,
    this.attachmentData, // Initialize with null
  });
}
