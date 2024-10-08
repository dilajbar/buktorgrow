import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controller/video_controller.dart';

class VideoplayerBubble extends StatelessWidget {
  final String videourl;
  final bool isSentByUser;
  final bool seen;
  final bool delivered;

  const VideoplayerBubble({
    super.key,
    required this.videourl,
    required this.isSentByUser,
    required this.seen,
    required this.delivered,
  });

  @override
  Widget build(BuildContext context) {
    final videoController = Get.put(VideoController());

    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSentByUser ? Colors.green[100] : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSentByUser ? 12 : 0),
            topRight: Radius.circular(isSentByUser ? 0 : 12),
            bottomLeft: const Radius.circular(12),
            bottomRight: const Radius.circular(12),
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          crossAxisAlignment:
              isSentByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Use GetX to handle the video player state reactively
            GetX<VideoController>(
              initState: (_) {
                // Only initialize if it's not already initialized
                if (!videoController.isInitialized.value) {
                  videoController.initialize(videourl);
                }
              },
              builder: (_) {
                if (videoController.isInitialized.value) {
                  return AspectRatio(
                    aspectRatio:
                        videoController.videoPlayerController.value.aspectRatio,
                    child: Stack(
                      children: [
                        VideoPlayer(videoController.videoPlayerController),
                        Center(
                          child: IconButton(
                            onPressed: videoController.playPause,
                            icon: Icon(
                              videoController.isPlaying.value
                                  ? Icons.pause
                                  : Icons.play_circle,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Show shimmer while the video is loading
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 200, // You may need to set a default height
                      color: Colors.white,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: isSentByUser
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                const Text("video "),
                if (isSentByUser) ...[
                  delivered
                      ? const Icon(Icons.done_all, color: Colors.blue, size: 16)
                      : const Icon(Icons.done, color: Colors.grey, size: 16),
                  const SizedBox(width: 4),
                  seen
                      ? const Icon(Icons.visibility,
                          color: Colors.blue, size: 16)
                      : const SizedBox.shrink(),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
