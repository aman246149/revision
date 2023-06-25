import 'package:dsanotes/services/video_play_service.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProvider extends ChangeNotifier {
  final VideoPlayService _videoService;

  VideoProvider(this._videoService);
  bool isVideoLoading = true;

  VideoPlayerController get videoPlayerController =>
      _videoService.videoController;

  Future<void> setVideoPath(String videoPath, bool isLocalSource) async {
    await _videoService.initializeVideo(videoPath, isLocalSource);
    isVideoLoading = false;
    _videoService.play();
    notifyListeners();
  }

  void closeVideoPlayer() {
    isVideoLoading = true;
    _videoService.stop();
  }
}
