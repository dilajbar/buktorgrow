import 'package:buktorgrow/controller/chat_controller.dart';
import 'package:buktorgrow/widgets/icon_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/textbar_controller.dart';

class TextBar extends StatelessWidget {
  final String? phone;
  const TextBar({super.key, this.phone});

  @override
  Widget build(BuildContext context) {
    final TextBarController controller = Get.put(TextBarController());

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
                      } else {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              controller: controller.chatmessageController,
                              minLines: 1,
                              maxLines: 5,
                              onChanged: (text) {
                                controller.updateMessage;
                                controller.updateTextFieldStatus(text);
                              },
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
                                        _showIconPopup(
                                            context, phone.toString());
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
                                        controller.openCamera(phone);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              style: GoogleFonts.aBeeZee(),
                            ),
                          ),
                        );
                      }
                    }),
                    const SizedBox(width: 5),
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
                            controller.stopRecording(phone);
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
