import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  late VideoPlayerController videoPlayerController;
  var isPlaying = false.obs;
  var isInitialized = false.obs;

  Future<void> initialize(String videourl) async {
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videourl));
    await videoPlayerController.initialize();
    isInitialized.value = true;
    isPlaying.value = videoPlayerController.value.isPlaying;
    update(); // Notifies the listeners
  }

  void playPause() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
      isPlaying.value = false;
    } else {
      videoPlayerController.play();
      isPlaying.value = true;
    }
    update(); // Notify UI of changes
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    super.onClose();
  }
}
