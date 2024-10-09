import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  var isPlaying = false.obs;
  var isInitialized = false.obs;
  var isLoading = false.obs;

  Future<void> initialize(String videourl) async {
    isLoading.value = true;
    update();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videourl))..initialize().then((value) {
          
        },);
        
   
//     await videoPlayerController.initialize().then((value) {
//       videoPlayerController.addListener(() {
//         chewieController = ChewieController(
//   videoPlayerController: videoPlayerController,
//   autoPlay: true,
//   looping: true,
// ); 
//    },);
//     },);
    isInitialized.value = true;
    isPlaying.value = videoPlayerController.value.isPlaying;
    isLoading.value = false;
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
   //   chewieController.dispose();

    super.onClose();
  }
}
