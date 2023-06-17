import 'package:injectable/injectable.dart';
import 'package:video_player/video_player.dart';

@lazySingleton
class VideoService {
  late VideoPlayerController _controller;

  VideoService();

  Future<void> initializeVideo(String videoPath) async {
    _controller = VideoPlayerController.network(videoPath);
    await _controller.initialize();
  }

  void play() {
    _controller.play();
  }

  void pause() {
    _controller.pause();
  }

  void stop() {
    _controller.seekTo(Duration.zero);
    _controller.pause();
  }

  void dispose() {
    _controller.dispose();
  }

  VideoPlayerController get videoController => _controller;
}