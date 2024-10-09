import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:buktorgrow/controller/new_chat_controller.dart';
import 'package:buktorgrow/models/individual_chat_model.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../database/services/message_send_service.dart';

class TextBarController extends GetxController {
  var showAttachments = false.obs;
  var message = ''.obs;
  var isRecording = false.obs;
  var voiceMessagePath = ''.obs;
  var isTextFieldEmpty = true.obs;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();
  var filePath = Rx<String>('');

  var isPlaying = false.obs;
  var errorMessage = ''.obs;
  var isPermissionDenied = false.obs;
  var recordingDuration = 0.obs;
  Timer? _timer;
  var isLoading = false.obs;

  late VoiceController voiceController;
  final TextEditingController chatmessageController = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  void toggleAttachments() => showAttachments.value = !showAttachments.value;

  void updateMessage(String newMessage) => message.value = newMessage;
  void updateTextFieldStatus(String input) {
    isTextFieldEmpty.value = input.trim().isEmpty;
  }

  void onMessageChanged(String message) {
    updateMessage(message); // Update the message
    updateTextFieldStatus(message); // Check if the text field is empty or not
  }

  Future<void> sendMessage({
    String? phone,
  }) async {
    NewChatController newChatController = Get.find<NewChatController>();

    print("messge++++++++++++${message.value}");
    if (message.value.isNotEmpty) {
      log('Sending message: ${message.value}');

      // send to local list

      newChatController.newMessages.value
          .add(ChatThread(value: LastChat(
            type: 'inbound',
            metadata: Metadata(
            text: TextMetadata(body: message.value)
          ))));

      var response = await MessageSendService()
          .sendMessage(message: message.value, phone: phone);
      if (response == true) {
        message.value = '';

        log('Message sent: ${message.value}');
      }
    } else if (voiceMessagePath.value.isNotEmpty) {
      log('Sending voice message: ${voiceMessagePath.value}');
      voiceMessagePath.value = '';
    }
  }

  Future<bool?> uploadFile(dynamic file, String? phone) async {
    try {
      // Determine the file type
      String fileName;
      String fileExtension;
      String mediatype;

      // Convert XFile to File if needed
      File? fileToUpload;
      if (file is File) {
        fileToUpload = file;
      } else if (file is XFile) {
        fileToUpload = File(file.path);
      } else {
        throw ArgumentError('Unsupported file type');
      }

      fileName = path.basename(fileToUpload.path);
      fileExtension = path.extension(fileToUpload.path).toLowerCase();

      log('File extension: $fileExtension');
      if (fileExtension == '.jpg' ||
          fileExtension == '.jpeg' ||
          fileExtension == '.png') {
        mediatype = 'image';
      } else if (fileExtension == '.mp4' || fileExtension == '.avi') {
        mediatype = 'video';
      } else if (fileExtension == '.mp3' ||
          fileExtension == '.wav' ||
          fileExtension == '.aac' ||
          fileExtension == '.ogg') {
        mediatype = 'audio';
      } else {
        mediatype = 'other';
      }

      // Upload the file
      UploadTask uploadTask =
          _storage.ref('uploads/$fileName').putFile(fileToUpload);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      log('File uploaded. URL: $downloadUrl');
      print('Uploaded file URL: $downloadUrl');

      // Sending the media
      var response = await MessageSendService().sendMedia(
        mediatype: mediatype,
        mediaurl: downloadUrl,
        phone: phone,
        filename: fileName,
      );

      if (response == true) {
        log('Media sent successfully');
        // Handle successful response
      } else {
        log('Failed to send media');
        // Handle unsuccessful response
      }
    } catch (e) {
      log('Error uploading file: $e');
      return false;
    }
  }

  Future<void> openDocumentPicker(String? phone) async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.any);
      if (result != null) {
        File file = File(result.files.single.path!);
        log('Picked document: ${result.files.single.path}');
        await uploadFile(file, phone);
      } else {
        log('No document selected');
      }
    } catch (e) {
      log('Error picking document: $e');
    }
  }

  Future<void> openCamera(String? phone) async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        log('Captured photo: ${photo.path}');
        await uploadFile(photo, phone);
      } else {
        log('No photo captured');
      }
    } catch (e) {
      log('Error capturing photo: $e');
    }
  }

  Future<void> openGallery(String? phone) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        log('Selected image: ${image.path}');
        await uploadFile(image, phone);
      } else {
        log('No image selected');
      }
    } catch (e) {
      log('Error selecting image: $e');
    }
  }

  Future<void> openAudioPicker(String? phone) async {
    try {
      final audio = await FilePicker.platform.pickFiles(
        type: FileType.custom, // Ensuring only allowed types are picked
        allowedExtensions: ['mp3', 'wav', 'aac', 'ogg'],
      );

      if (audio != null) {
        final PlatformFile platformFile = audio.files.single;
        final fileName = platformFile.name;
        final fileExtension = fileName.split('.').last.toLowerCase();

        // Validate file extension
        if (['mp3', 'wav', 'aac', 'ogg'].contains(fileExtension)) {
          log('Picked audio: $fileName');

          // Convert PlatformFile to File
          final File fileToUpload = File(platformFile.path!);

          // Now upload the file
          await uploadFile(fileToUpload, phone);
        } else {
          log('Unsupported file format: $fileExtension');
        }
      } else {
        log('No audio file selected');
      }
    } catch (e) {
      log('Error picking audio file: $e');
    }
  }

  Future<void> pickImage(String? phone) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        log('Picked image: ${image.path}');
        await uploadFile(image, phone);
      } else {
        log('No image selected');
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  Future<void> openVideoRecorder(String? phone) async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? video = await picker.pickVideo(
        source: ImageSource.camera, // Or ImageSource.gallery for gallery access
        maxDuration:
            const Duration(minutes: 5), // Set a max duration for the video
      );

      if (video != null) {
        final String fileName = video.name;
        final String fileExtension = fileName.split('.').last.toLowerCase();

        // Validate file extension
        if (['mp4', 'mov', 'avi', 'mkv'].contains(fileExtension)) {
          log('Picked video: $fileName');

          // Convert XFile to File
          final File fileToUpload = File(video.path);

          // Now upload the file
          final bool? uploadSuccess = await uploadFile(fileToUpload, phone);

          // If the upload is successful, show a toast
          if (uploadSuccess!) {
            Fluttertoast.showToast(
              msg: "Video uploaded successfully!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } else {
            Fluttertoast.showToast(
              msg: "Video upload failed!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        } else {
          log('Unsupported video format: $fileExtension');
        }
      } else {
        log('No video file selected');
      }
    } catch (e) {
      log('Error recording video: $e');
    }
  }

  Future<void> shareLocation(String? phone) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log('Location permissions are permanently denied.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      log('Current location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      log('Error sharing location: $e');
    }
  }

  void openContacts(String? phone) {
    log('Opening contacts...');
    // Implement contact picker functionality here
  }

  Future<void> checkAndRequestPermission() async {
    var status = await Permission.microphone.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      // Update permission status
      isPermissionDenied.value = true;
      // Request permission
      await Permission.microphone.request();
      // Re-check the permission status
      status = await Permission.microphone.status;
      isPermissionDenied.value = status.isDenied;
    } else {
      isPermissionDenied.value = false;
    }
  }

  void onLongPressHandler() async {
    // Only start recording if permission has already been granted
    if (await _audioRecorder.hasPermission()) {
      startRecording();
    } else {
      errorMessage.value = 'Microphone permission denied or not requested.';
    }
  }

  void onTapHandler() async {
    // Request permission separately before allowing recording on long press
    await checkAndRequestPermission();
  }

  Future<void> startRecording() async {
    if (kIsWeb) {
      errorMessage.value = 'Audio recording is not supported on web.';
      return;
    }

    // Ensure permission is granted before starting recording
    if (await _audioRecorder.hasPermission()) {
      String? directoryPath;
      if (Platform.isAndroid || Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        directoryPath =
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp3';
        log(directoryPath);
      }

      String filePath = directoryPath ?? ''; // Assign the path

      try {
        await _audioRecorder.start(const RecordConfig(),
            path: filePath); // Start recording
        isRecording.value = true;
        recordingDuration.value = 0; // Reset timer

        // Start a timer to count seconds
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          recordingDuration.value++; // Increment timer every second
        });
      } catch (e) {
        errorMessage.value = 'Failed to start recording: $e';
      }
    } else {
      errorMessage.value = 'Microphone permission denied';
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording.value) return;

    try {
      final path = await _audioRecorder.stop();
      if (path != null) {
        filePath.value = path; // Assign the file path for the recorded audio
        isRecording.value = false;

        // The file path is set, and now the user can review and decide to delete or send the audio
      }
      _timer?.cancel();
    } catch (e) {
      errorMessage.value = 'Failed to stop recording: $e';
    }
  }

  Future<void> playAudio(String audioFilePath) async {
    try {
      isPlaying.value = true;
      await _audioPlayer.setFilePath(audioFilePath);
      _audioPlayer.play();
    } catch (e) {
      errorMessage.value = 'Failed to play audio: $e';
    }
  }

  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
      isPlaying.value = false;
    } catch (e) {
      errorMessage.value = 'Failed to stop audio: $e';
    }
  }

  void deleteRecordedAudio() {
    if (filePath.value.isNotEmpty) {
      try {
        // Delete the audio file from the system if it exists
        File(filePath.value).deleteSync();
        filePath.value = ''; // Clear the file path
        isRecording.value = false; // Reset recording status
        errorMessage.value = 'Recorded audio has been deleted.';
      } catch (e) {
        errorMessage.value = 'Failed to delete audio: $e';
      }
    } else {
      errorMessage.value = 'No audio recorded to delete.';
    }
  }

  // Sending the recorded audio file
  var isVoiceSending = false.obs;

  Future<void> sendRecordedAudio(String? phone) async {
    isVoiceSending.value = true;
    update();
    try {
      if (filePath.value.isNotEmpty) {
        // Convert the recorded file to OGG format before uploading
        String oggPath = await convertToOgg(filePath.value);

        // Send the converted OGG audio file
        await uploadRecordedAudio(File(oggPath), phone).then(
          (value) {
            onClear();
            isVoiceSending.value = false;
            update();
          },
        );
        errorMessage.value = 'Audio sent successfully.';
      } else {
        errorMessage.value = 'No audio file to send.';
      }
    } catch (e) {
      errorMessage.value = 'Failed to send audio: $e';
    }
  }

  Future<String> convertToOgg(String inputPath) async {
    // Create the output path by replacing .mp3 with .ogg
    String outputPath = inputPath.replaceAll('.mp3', '.ogg');

    // FFmpeg command to convert mp3 to ogg
    String command = '-i $inputPath $outputPath';

    // Execute FFmpeg command
    FFmpegSession session = await FFmpegKit.execute(command);

    final returnCode = await session.getReturnCode();

    if (returnCode!.isValueSuccess()) {
      log('Audio conversion successful: $outputPath');
      return outputPath; // Return the path of the converted OGG file
    } else {
      throw Exception('Failed to convert audio to OGG');
    }
  }

  Future<void> uploadRecordedAudio(dynamic file, String? phone) async {
    try {
      // Convert XFile to File if needed
      File? fileToUpload;
      if (file is File) {
        fileToUpload = file;
      } else if (file is XFile) {
        fileToUpload = File(file.path);
      } else {
        throw ArgumentError('Unsupported file type');
      }

      // Call the uploadFile function to handle uploading the audio file
      await uploadFile(fileToUpload, phone);
    } catch (e) {
      log('Error uploading recorded audio: $e');
    }
  }

  // Audio playback (works across platforms)

  // Clear audio data
  void onClear() {
    filePath.value = '';
    errorMessage.value = '';
    stopRecording();
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    _audioRecorder.dispose();

    super.onClose();
  }
}
