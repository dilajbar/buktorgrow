import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/chat_controller.dart';
import 'attachment_icon.dart';

class AttachmentPad extends StatelessWidget {
  const AttachmentPad({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AttachmentIcon(
          icon: Icons.insert_drive_file,
          label: 'Document',
          onTap: () async {
            try {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: [
                  'pdf',
                  'doc',
                  'jpeg',
                  'jpg',
                  'png',
                  'svg',
                  'mp3'
                ],
              );
              if (result != null) {
                chatController.sendAttachment(
                  result.files.single.name,
                  Icons.insert_drive_file,
                );
              }
            } catch (e) {
              log(e.toString());
            }
          },
        ),
        AttachmentIcon(
          icon: Icons.camera_alt,
          label: 'Camera',
          onTap: () async {
            try {
              final picker = ImagePicker();
              final pickedFile =
                  await picker.pickImage(source: ImageSource.camera);
              if (pickedFile != null) {
                chatController.sendAttachment(pickedFile.name, Icons.camera_alt,
                    attachmentData: pickedFile);
              }
            } catch (e) {
              log(e.toString());
            }
          },
        ),
        AttachmentIcon(
          icon: Icons.photo,
          label: 'Gallery',
          onTap: () async {
            try {
              final picker = ImagePicker();
              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                chatController.sendAttachment(pickedFile.name, Icons.photo,
                    attachmentData: pickedFile);
              }
            } catch (e) {
              log(e.toString());
            }
          },
        ),
        AttachmentIcon(
          icon: Icons.audiotrack,
          label: 'Audio',
          onTap: () async {
            try {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.audio,
              );
              if (result != null) {
                chatController.sendAttachment(
                    result.files.single.name, Icons.audiotrack,
                    attachmentData: result.files.first.xFile);
              }
            } catch (e) {
              log(e.toString());
            }
          },
        ),
        AttachmentIcon(
          icon: Icons.location_on,
          label: 'Location',
          onTap: () async {
            try {
              bool serviceEnabled;
              LocationPermission permission;

              // Check if location services are enabled
              serviceEnabled = await Geolocator.isLocationServiceEnabled();
              if (!serviceEnabled) {
                return Future.error('Location services are disabled.');
              }

              // Check for location permissions
              permission = await Geolocator.checkPermission();
              if (permission == LocationPermission.denied) {
                permission = await Geolocator.requestPermission();
                if (permission == LocationPermission.denied) {
                  return Future.error('Location permissions are denied.');
                }
              }

              if (permission == LocationPermission.deniedForever) {
                return Future.error(
                    'Location permissions are permanently denied.');
              }

              // Get the current location
              Position position = await Geolocator.getCurrentPosition();

              // Get the placemarks from coordinates
              List<Placemark> placemarks = await placemarkFromCoordinates(
                position.latitude,
                position.longitude,
              );

              // Extract the place name
              String placeName = placemarks.isNotEmpty
                  ? '${placemarks.first.locality}, ${placemarks.first.country}'
                  : 'Unknown location';

              // Send the location data to the chat controller
              log('Lat: ${position.latitude}, Long: ${position.longitude}, Place: $placeName');
              chatController.sendAttachment(
                'Latitude: ${position.latitude}, Longitude: ${position.longitude}, Place: $placeName',
                Icons.location_on,
              );
            } catch (e) {
              Fluttertoast.showToast(msg: e.toString());
              log(e.toString());
            }
          },
        ),
      ],
    );
  }
}
