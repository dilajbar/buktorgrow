// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:record/record.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../controller/chat_controller.dart';
// import '../helpers/custome_color.dart';
// import '../widgets/attachment_pad.dart';
// import '../widgets/chat_bubble.dart';
// import 'home_page.dart';

// class ChatPage extends StatefulWidget {
//   final ChatItem chatItem;

//   const ChatPage({super.key, required this.chatItem});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _audioRecorder.dispose();
//     super.dispose();
//   }

//   final AudioRecorder _audioRecorder = AudioRecorder();

//   String? _recordingPath;

//   final ChatController chatController = Get.put(ChatController());

//   final textEditingController = TextEditingController();

//   final RxString messageText = ''.obs;

//   @override
//   Widget build(BuildContext context) {
//     textEditingController.addListener(() {
//       messageText.value = textEditingController.text;
//     });

//     return Scaffold(
//       backgroundColor: CustomColors().extraColor,
//       appBar: AppBar(
//         backgroundColor: CustomColors().extraColor,
//         surfaceTintColor: CustomColors().extraColor,
//         title: Text(
//           widget.chatItem.name,
//           style: GoogleFonts.aBeeZee(fontSize: 20),
//         ),
//         actions: [
//           IconButton(
//               icon: const Icon(Icons.call_outlined),
//               onPressed: () {
//                 makePhoneCall('+919876543210');
//               }),
//           PopupMenuButton<String>(
//             offset: const Offset(100, 50),
//             color: CustomColors().extraColor,
//             elevation: 0,
//             onSelected: (String value) {
//               switch (value) {
//                 case 'Clear Chat':
//                   clearChat();
//                   break;
//                 case 'Block':
//                   blockUser();
//                   break;
//                 case 'Mute':
//                   muteChat();
//                   break;
//               }
//             },
//             itemBuilder: (BuildContext context) {
//               return {'Clear Chat', 'Block', 'Mute'}.map((String choice) {
//                 return PopupMenuItem<String>(
//                   height: 30,
//                   value: choice,
//                   child: Text(
//                     choice,
//                     style: GoogleFonts.aBeeZee(),
//                   ),
//                 );
//               }).toList();
//             },
//             icon: const Icon(Icons.more_vert),
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/chat_background_wallpapper.png'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//           child: Column(
//             children: [
//               Expanded(child: _buildChatList()),
//               Obx(() => chatController.isAttachmentVisible.value
//                   ? const AttachmentPad()
//                   : const SizedBox.shrink()),
//               const SizedBox(height: 5),
//               _buildInputArea(),
//               const SizedBox(height: 5),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildChatList() {
//     return Obx(() {
//       return ListView.builder(
//         itemCount: chatController.messages.length,
//         itemBuilder: (context, index) {
//           final message = chatController.messages[index];
//           return ChatBubble(message: message);
//         },
//       );
//     });
//   }

//   Future<void> _startRecording() async {
//     try {
//       if (await _audioRecorder.hasPermission()) {
//         print("Starting recording...");
//         await _audioRecorder.start(const RecordConfig(),
//             path: 'aFullPath/myFile.m4a');
//         print("Recording started successfully.");
//       }
//     } catch (e) {
//       print('Error starting recording: $e');
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       _recordingPath = (await _audioRecorder.stop())!;
//     } catch (e) {
//       log('Error stopping recording: $e');
//     }
//   }

//   Widget _buildInputArea() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 5),
//       child: Row(
//         children: [
//           Expanded(
//             child: Stack(
//               children: [
//                 TextFormField(
//                   minLines: 1,
//                   maxLines: 5,
//                   controller: textEditingController,
//                   decoration: InputDecoration(
//                     hintText: 'Type a message',
//                     hintStyle: GoogleFonts.aBeeZee(fontSize: 14),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: const BorderSide(color: Colors.white),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: const BorderSide(color: Colors.white),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: const BorderSide(color: Colors.white),
//                     ),
//                   ),
//                   style: GoogleFonts.aBeeZee(),
//                 ),
//                 Positioned(
//                   right: 0,
//                   top: 0,
//                   bottom: 0,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           Icons.attach_file_outlined,
//                           // size: 20,
//                           color: Colors.grey.shade600,
//                         ),
//                         onPressed: chatController.toggleAttachmentVisibility,
//                       ),
//                       IconButton(
//                         icon: Icon(
//                           Icons.camera_alt,
//                           // size: 20,
//                           color: Colors.grey.shade600,
//                         ),
//                         onPressed: () async {
//                           try {
//                             final picker = ImagePicker();
//                             final pickedFile = await picker.pickImage(
//                                 source: ImageSource.camera);
//                             if (pickedFile != null) {
//                               chatController.sendAttachment(
//                                   pickedFile.name, Icons.camera_alt,
//                                   attachmentData: pickedFile);
//                             }
//                           } catch (e) {
//                             log(e.toString());
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 5),
//           Obx(
//             () => messageText.value.isEmpty
//                 ? GestureDetector(
//                     onLongPressStart: (_) async {
//                       chatController.setMicPressed(true);
//                       // await _startRecording();
//                     },
//                     onLongPressEnd: (_) async {
//                       chatController.setMicPressed(false);
//                       // await _stopRecording();
//                       // if (_recordingPath != null) {
//                       //   chatController.sendAttachment("Voice note", Icons.mic,
//                       //       attachmentData: XFile(_recordingPath!));
//                       // }
//                       chatController.sendAttachment("Voice note", Icons.mic);
//                     },
//                     child: Obx(() => AnimatedContainer(
//                           duration: const Duration(milliseconds: 200),
//                           height: chatController.isMicPressed.value ? 70 : 50,
//                           width: chatController.isMicPressed.value ? 70 : 50,
//                           decoration: const BoxDecoration(
//                             color: Colors.green,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.mic,
//                             color: Colors.white,
//                             size: chatController.isMicPressed.value ? 35 : 22,
//                           ),
//                         )),
//                   )
//                 : GestureDetector(
//                     onTap: () {
//                       final text = textEditingController.text;
//                       if (text.isNotEmpty) {
//                         chatController.sendMessage(text);
//                         textEditingController.clear();
//                       }
//                     },
//                     child: Container(
//                       height: 50,
//                       width: 50,
//                       decoration: const BoxDecoration(
//                         color: Colors.green,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.send,
//                         size: 22,
//                         color: Colors.white,
//                       ),
//                     )),
//           ),
//         ],
//       ),
//     );
//   }

//   void makePhoneCall(String phoneNumber) async {
//     if (phoneNumber != '' && phoneNumber.isNotEmpty) {
//       final String url = 'tel:$phoneNumber';
//       final Uri uri = Uri.parse(url);
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri);
//       } else {
//         log('Could not launch $url');
//       }
//     } else {
//       log('Phone number is null or empty');
//     }
//   }

//   void clearChat() {
//     log('Chat cleared');
//   }

//   void blockUser() {
//     log('User blocked');
//   }

//   void muteChat() {
//     log('Chat muted');
//   }
// }
