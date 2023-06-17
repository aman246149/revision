import 'package:dsanotes/services/video_service.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProvider extends ChangeNotifier {
  final VideoService _videoService;

  VideoProvider(this._videoService);
  bool isVideoLoading = true;

  VideoPlayerController get videoPlayerController =>
      _videoService.videoController;

  void setVideoPath(String videoPath) async {
    await _videoService.initializeVideo(videoPath);
    isVideoLoading = false;
    _videoService.play();
    notifyListeners();
  }

  void closeVideoPlayer() {
    _videoService.stop();
  }
}
