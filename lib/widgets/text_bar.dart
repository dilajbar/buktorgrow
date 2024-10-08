import 'package:buktorgrow/widgets/icon_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../controller/textbar_controller.dart';

class TextBar extends StatelessWidget {
  final String? phone;
  const TextBar({super.key, this.phone});

  @override
  Widget build(BuildContext context) {
    final TextBarController controller = Get.put(TextBarController());
    final FocusNode focusNode = FocusNode();
    controller.checkAndRequestPermission();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/chat_background_wallpapper.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Obx(() {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          //   if (controller.showAttachments.value)
          Wrap(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/chat_background_wallpapper.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      if (controller.isRecording.value) {
                        final minutes =
                            (controller.recordingDuration.value ~/ 60)
                                .toString()
                                .padLeft(2, '0');
                        final seconds =
                            (controller.recordingDuration.value % 60)
                                .toString()
                                .padLeft(2, '0');

                        return Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                'Recording   $minutes:$seconds',
                                style: GoogleFonts.aBeeZee(
                                    fontSize: 16, color: Colors.redAccent),
                              ),
                            ),
                          ),
                        );
                      } else if (!controller.isRecording.value &&
                          controller.filePath.isEmpty) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              controller: controller.chatmessageController,
                              focusNode: focusNode,
                              minLines: 1,
                              maxLines: 5,
                              onChanged: controller.onMessageChanged,
                              decoration: InputDecoration(
                                hintText: 'Type a message',
                                hintStyle: GoogleFonts.aBeeZee(fontSize: 14),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                ),
                                prefixIcon: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.emoji_emotions_outlined,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        focusNode.requestFocus();
                                        _showIconPopup(
                                            context, phone.toString());
                                        focusNode.unfocus();
                                      },
                                      icon: Icon(
                                        Icons.attach_file_outlined,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey.shade600,
                                      ),
                                      onPressed: () {
                                        focusNode.requestFocus();
                                        controller.openCamera(phone);
                                        focusNode.unfocus();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              style: GoogleFonts.aBeeZee(),
                            ),
                          ),
                        );
                      } else if (controller.filePath.isNotEmpty &&
                          !controller.isRecording()) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  iconSize: 28,
                                  icon: const CircleAvatar(
                                      child: Center(
                                          child: Icon(Icons.delete,
                                              color: Colors.black))),
                                  onPressed: () async {
                                    controller.deleteRecordedAudio();
                                  },
                                ),
                                VoiceMessageView(
                                  //size: ,
                                  activeSliderColor: Colors.green,
                                  circlesColor: Colors.black,
                                  controller: VoiceController(
                                    maxDuration: const Duration(minutes: 5),
                                    isFile: true,
                                    audioSrc: controller.filePath.value,
                                    onComplete: () {},
                                    onPause: () {},
                                    onPlaying: () {},
                                    onError: (err) {},
                                  ),
                                  innerPadding: 12,
                                  cornerRadius: 20,
                                ),
                                IconButton(
                                  iconSize: 28,
                                  icon: controller.isVoiceSending.value? const CircularProgressIndicator(): const CircleAvatar(
                                      child: Center(
                                          child: Icon(Icons.send,
                                              color: Colors.black))),
                                  onPressed: () async {
                                    await controller.sendRecordedAudio(phone);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
                    const SizedBox(width: 5),
                 if(controller.filePath.value.isEmpty)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: controller.isRecording.value ? 80.0 : 55.0,
                      height: controller.isRecording.value ? 80.0 : 55.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green[700],
                      ),
                      child: Obx(() {
                        // Wrap this with Obx to reactively update
                        return GestureDetector(
                          onTap: () {
                            if (controller.chatmessageController.text
                                .trim()
                                .isNotEmpty) {
                              controller.sendMessage(phone: phone);

                              controller.chatmessageController.clear();
                              controller.updateTextFieldStatus('');
                            }
                          },
                          onLongPress: () {
                            if (controller.isTextFieldEmpty.value) {
                              controller.onLongPressHandler();
                            }
                          },
                          onLongPressUp: () {
                            controller.stopRecording();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: controller.isRecording.value
                                ? const EdgeInsets.all(
                                    20.0) // Larger padding when recording
                                : const EdgeInsets.all(15.0), // Normal padding
                            decoration: const BoxDecoration(
                                color: Color(0xff25D366),
                                shape: BoxShape.circle),
                            child: Icon(
                              controller.isTextFieldEmpty.value
                                  ? Icons.mic
                                  : Icons.send,
                              size: controller.isRecording.value
                                  ? 40 // Larger icon when recording
                                  : 24, // Normal icon size
                            ),
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),
            ],
          )
        ]);
      }),
    );
  }

  void _showIconPopup(BuildContext context, String phone) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return IconPopup(
          phone: phone,
        );
      },
    );
  }
}
