import 'dart:async';
import 'dart:developer';

import 'package:dsanotes/services/database_service.dart';
import 'package:dsanotes/services/hive_adapters/notes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';

import '../services/audio_service.dart';

typedef VoidCallback = void Function();

class AudioProvider extends ChangeNotifier {
  final AudioService _audioService;
  final DataBaseService _dataBaseService;

  AudioProvider(this._audioService, this._dataBaseService);

  bool get isRecorderInited => _audioService.isRecorderInited;
  bool get isPlaybackReady => _audioService.isPlaybackReady;
  bool get isPlayerInited => _audioService.isPlayerInited;
  bool get isLoading => _isLoading;
  List<Notes> get recordingList => _recordingList;

  List<Notes> _recordingList = [];
  FlutterSoundPlayer? get player => _audioService.player;
  FlutterSoundRecorder? get recorder => _audioService.recorder;
  bool _isLoading = false;

  bool isPlayForDb = false;
  String _currentPlayingRecording = "";
  Set<String> filters = {};

  StreamController<Duration>? duration = StreamController.broadcast();
  StreamController<Duration>? position = StreamController.broadcast();
  StreamSubscription<PlaybackDisposition>? playerOnProgress;

  Future<void> initAudioService() async {
    await _audioService.init();
    print(duration);
    getOnProgress();
  }

  Future<void> _record() async {
    await _audioService.record();
    notifyListeners();
  }

  Future<void> _stopRecorder() async {
    await _audioService.stopRecorder();
    notifyListeners();
  }

  Future<void> _play() async {
    if (isPlayForDb) {
      var soundBytesString =
          await _dataBaseService.getBox(_currentPlayingRecording);
      if (soundBytesString != null) {
        // Sound bytes string retrieved successfully
        // Use the sound bytes string as needed
        _audioService.setAudioPath(soundBytesString.filePath!);
      } else {
        print("error sound corrputed");
        return;
      }
    }
    await _audioService.play();
    notifyListeners();
  }

  Future<void> _stopPlayer() async {
    await _audioService.stopPlayer();
    notifyListeners();
  }

  void startStopRecorder() async {
    try {
      if (!isRecorderInited || !player!.isStopped) {
        print("recorder is Stopped");
      }
      print("start stop");
      recorder!.isStopped ? await _record() : await _stopRecorder();
      if (recorder!.isStopped) {
        Future.delayed(
          const Duration(seconds: 1),
          () {
            getListAllRecordingNotes();
          },
        );
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void startStopPlayer() async {
    try {
      if (!isPlayerInited || !isPlaybackReady || !recorder!.isStopped) {
        print("player is Stopped");
      }
      player!.isStopped ? _play() : _stopPlayer();

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getListAllRecordingNotes() async {
    try {
      _isLoading = true;

      List<dynamic> keys = await _dataBaseService.getAllDataKeys();
      for (var key in keys) {
        var notes = await _dataBaseService.getBox(key) as Notes?;
        if (notes != null) {
          notes.key = key;
          _recordingList.add(notes);
          filters.add(notes.topicName ?? "");
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("err");
    }
  }

  void setCurrentPlayingRecording(String key) {
    _currentPlayingRecording = key;
  }

  void seek(Duration position) {
    player!.seekToPlayer(position);
  }

  void getOnProgress() {
    player!.setSubscriptionDuration(const Duration(milliseconds: 100));
    playerOnProgress = player!.onProgress!.listen((event) {
      log(event.duration.toString());
      duration!.add(event.duration);
      position!.add(event.position);
    });
  }

  void cancelAllSubscriptions() {
    print("cancelling all streams");
    // duration?.close();
    // position?.close();
    // playerOnProgress?.cancel();
    _audioService.stopPlayer();
  }
}
