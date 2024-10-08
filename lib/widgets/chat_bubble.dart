import 'dart:developer';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/messages_model.dart';

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      alignment:
          message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 250),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          color: message.isSentByMe ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(15),
            bottomRight: const Radius.circular(15),
            topLeft: message.isSentByMe
                ? const Radius.circular(15)
                : const Radius.circular(0),
            topRight: message.isSentByMe
                ? const Radius.circular(0)
                : const Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            message.isAttachment
                ? Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAttachment(context),
                        ],
                      ),
                    ],
                  )
                : Text(
                    message.text,
                    style: GoogleFonts.aBeeZee(color: Colors.white),
                  ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.timestamp.toString(),
                  style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 8),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.done_all, color: Colors.white, size: 12)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachment(BuildContext context) {
    if (message.isAttachment) {
      if (message.attachmentData != null) {
        if (message.attachmentIcon == Icons.photo ||
            message.attachmentIcon == Icons.camera_alt) {
          return GestureDetector(
            onTap: () {
              _showFullScreenImage(context, message.attachmentData!);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                message.attachmentData!,
                height: 300,
                width: 250,
                fit: BoxFit.cover,
              ),
            ),
          );
        } else if (message.attachmentIcon == Icons.mic) {
          return GestureDetector(
            onTap: () async {
              final player = AudioPlayer();
              String path = String.fromCharCodes(message.attachmentData!);
              await player.play(DeviceFileSource(path));
            },
            child: const Row(
              children: [
                Icon(Icons.play_arrow),
                Text('Play Voice Note'),
              ],
            ),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(message.attachmentIcon),
              Text(
                message.text,
                style: GoogleFonts.aBeeZee(color: Colors.white),
              ),
            ],
          );
        }
      } else {
        if (message.attachmentIcon == Icons.location_on) {
          return GestureDetector(
            onTap: () {
              try {
                final coordinates = message.text
                    .replaceAll('Latitude: ', '')
                    .replaceAll(' Longitude: ', '')
                    .split(',');
                final lat = coordinates[0].trim();
                final long = coordinates[1].trim();
                openMap(lat, long);
              } catch (e) {
                log(e.toString());
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(message.attachmentIcon),
                Text(
                  message.text,
                  style: GoogleFonts.aBeeZee(color: Colors.white),
                ),
              ],
            ),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(message.attachmentIcon),
              Text(
                message.text,
                style: GoogleFonts.aBeeZee(color: Colors.white),
              ),
            ],
          );
        }
      }
    } else {
      return Text(
        message.text,
        style: GoogleFonts.aBeeZee(color: Colors.white),
      );
    }
  }

  void openMap(String lat, String long) async {
    try {
      final googleMapsUrl =
          'https://www.google.com/maps/search/?api=1&query=$lat,$long';
      final Uri uri = Uri.parse(googleMapsUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $googleMapsUrl';
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

void _showFullScreenImage(BuildContext context, Uint8List imageData) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Center(
              child: InteractiveViewer(
                panEnabled: true, // Set it to false to disable panning.
                minScale: 0.5,
                maxScale: 2,
                child: Image.memory(
                  imageData,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
