import 'dart:developer';

import 'package:buktorgrow/widgets/videoplayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:shimmer/shimmer.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../controller/new_chat_controller.dart';
import '../helpers/custome_color.dart';
import '../models/individual_chat_model.dart';
import '../widgets/text_bar.dart';

class ChatPage extends StatelessWidget {
  final String contactId;
  final String? name;
  final String? avatar;
  final String? phone;
  final DateTime? latestChatCreatedAt;
  final NewChatController chatcontroller;

  ChatPage(
      {super.key,
      required this.contactId,
      this.name,
      this.latestChatCreatedAt,
      this.avatar,
      this.phone})
      : chatcontroller = Get.put(NewChatController(contactId));

  @override
  Widget build(BuildContext context) {
    final contact = chatcontroller.chatData.value.contact;
    chatcontroller.formatDate(latestChatCreatedAt);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors().tertiaryColor,
        surfaceTintColor: CustomColors().tertiaryColor,
        title: Row(
          children: [
            avatar != null
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(avatar!),
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundImage: contact?.avatar != null
                        ? NetworkImage(contact!.avatar!)
                        : null,
                    child: contact?.avatar == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    phone ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined),
            onPressed: () {
              chatcontroller.makePhoneCall(phone ?? contact!.phone.toString());
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Add more options functionality if needed
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/chat_background_wallpapper.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Obx(
                
                (){
                  return PagedListView<int, ChatThread>(
                  reverse: true,
                  pagingController: chatcontroller.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<ChatThread>(
                    itemBuilder: (context, message, index) {
                      final isSentByUser = message.value?.type == 'outbound';
                      final metaData = message.value?.metadata;
                      final body = metaData!.text;
                  
                      final timestamp = message.value?.createdAt;
                      final status = message.value?.status == 'read';
                      final delivered = message.value?.status == 'delivered';
                      final mediaUrl = message.value?.media?.path;
                      final mediatype = message.value?.media?.type;
                            log("media url : $mediaUrl");
                      // Format the timestamp as needed
                      final formattedTime = timestamp != null
                          ? DateFormat('h:mm a').format(timestamp.toLocal())
                          : '';
                      // Check if the message contains media
                      Widget messageWidget;
                
                      if (mediaUrl != null && mediaUrl.isNotEmpty) {
                        if (mediatype == "audio/ogg" ||
                            mediatype == "application/ogg" ||
                            mediatype == "audio/mpeg") {
                          // Use the VoiceMessage widget to play the voice message
                         // messageWidget = const SizedBox.shrink();
                          messageWidget = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VoiceMessageView(
                                circlesColor: Colors.green,
                                playPauseButtonLoadingColor: Colors.green,
                                activeSliderColor: Colors.green,
                                controller: VoiceController(
                                  audioSrc: mediaUrl,
                                  onComplete: () {
                                    log('Voice message completed');
                                  },
                                  onPause: () {
                                    log('Voice message paused');
                                  },
                                  onPlaying: () {
                                    log('Voice message is playing');
                                  },
                                  onError: (err) {
                                    log(mediaUrl);
                                    log('Error playing voice message: $err');
                                    Fluttertoast.showToast(
                                      msg: "Error playing voice message",
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white,
                                    );
                                  },
                                  maxDuration: const Duration(minutes: 2),
                                  isFile: false,
                                ),
                                innerPadding: 12,
                                cornerRadius: 20,
                              ),
                            ],
                          );
                        } else if (mediatype == "video/mp4") {
                          // messageWidget = const SizedBox.shrink();
                          messageWidget = VideoplayerBubble(
                            videourl: mediaUrl,
                            isSentByUser: isSentByUser,
                            seen: isSentByUser ? status : false,
                            delivered: isSentByUser ? delivered : false,
                          );
                        } else {
                          messageWidget = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Stack(
                                  children: [
                                    // The image displayed inside the BubbleNormalImage
                                    BubbleNormalImage(
                                      id: 'id$index',
                                      image: CachedNetworkImage(
                                        imageUrl: mediaUrl,
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: double.infinity,
                                            color: Colors.white,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        fit: BoxFit.cover,
                                      ),
                                      color: CustomColors().primaryColor,
                                      tail: true,
                                      seen: isSentByUser ? status : false,
                                      delivered: isSentByUser ? delivered : false,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      } else if (body != null) {
                        // Display text if there's no media
                        messageWidget = BubbleSpecialThree(
                          text: body.body.toString(),
                          isSender: isSentByUser,
                          color:
                              isSentByUser ? Colors.green.shade400 : Colors.white,
                          tail: true,
                          seen: isSentByUser ? status : false,
                          delivered: isSentByUser ? delivered : false,
                          textStyle: TextStyle(
                            fontSize: 16,
                            color: isSentByUser ? Colors.white : Colors.black,
                          ),
                        );
                      } else {
                        // If both media and body are null, return an empty widget
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          crossAxisAlignment: isSentByUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            messageWidget,
                            const SizedBox(height: 2),
                            Text(
                              formattedTime,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    firstPageProgressIndicatorBuilder: (_) => const Center(
                        child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator())),
                    newPageProgressIndicatorBuilder: (_) => const Center(
                        child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator())),
                    noItemsFoundIndicatorBuilder: (_) =>
                        const Center(child: SizedBox.shrink()),
                  ),
                );
                }
               
              ),
            ),
          ),
          TextBar(phone: phone),
        ],
      ),
    );
  }
}
