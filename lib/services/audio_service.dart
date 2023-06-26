import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

const theSource = AudioSource.microphone;

@lazySingleton
class AudioService {
  Codec _codec = Codec.pcm16WAV;
  String _mPath = '';
  final FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  final FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;

  Future<void> init() async {
    try {
      await _mPlayer.openPlayer();
      _mPlayerIsInited = true;
    } catch (e) {
      print('Error opening player: $e');
      rethrow;
    }

    await openTheRecorder();

    if (_mPlayerIsInited && _mRecorderIsInited) {
      return;
    }

    await Future.delayed(const Duration(milliseconds: 100));
    await init();
  }

  Future<void> openTheRecorder() async {
    try {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }

      await _mRecorder.openRecorder();
      if (!await _mRecorder.isEncoderSupported(_codec)) {
        _codec = Codec.opusWebM;
        _mPath = 'tau_file.webm';
        if (!await _mRecorder.isEncoderSupported(_codec)) {
          _mRecorderIsInited = true;
          return;
        }
      }
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth |
                AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));

      _mRecorderIsInited = true;
    } catch (e) {
      print('Error opening recorder: $e');
      rethrow;
    }
  }

  Future<void> record(Function(String) whenRecordCompleted) async {
    try {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }

      var tempDir = await getTemporaryDirectory();
      var uniqueId = const Uuid().v4(); // Generate a unique identifier
      var extension =
          ext[_codec.index]; // Get the extension based on _codec.index
      var fileName =
          'flutter_sound$uniqueId$extension'; // Append the unique identifier and extension to the file name
      _mPath = path.join(
          tempDir.path, fileName); // Use path.join to create the dynamic path

      await _mRecorder.startRecorder(
        toFile: _mPath,
        codec: _codec,
        audioSource: theSource,
        bitRate: 16000,
        numChannels: 1,
      );

      // Delay for 1 second to ensure recording has started
      await Future.delayed(const Duration(milliseconds: 200));

      // Check the recording status periodically
      Timer.periodic(const Duration(milliseconds: 200), (Timer timer) async {
        var isRecording = _mRecorder.isRecording;
        if (!isRecording) {
          timer.cancel();

          whenRecordCompleted(_mPath);
        }
      });
    } catch (e) {
      print('Error starting recorder: $e');
      rethrow;
    }
  }

  Future<void> stopRecorder() async {
    try {
      await _mRecorder.stopRecorder();
      _mplaybackReady = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping recorder: $e');
      }
      rethrow;
    }
  }

  Future<void> play() async {
    try {
      assert(
        _mPlayerIsInited &&
            // _mplaybackReady &&
            // _mRecorder!.isStopped &&
            _mPlayer.isStopped,
      );
      await _mPlayer.startPlayer(
        fromURI: _mPath,
        whenFinished: () {},
      );
    } catch (e) {
      print('Error starting player: $e');
      rethrow;
    }
  }

  void setAudioPath(String audioPath) {
    _mPath = audioPath;
  }

  Future<void> stopPlayer() async {
    try {
      await _mPlayer.stopPlayer().then((value) {});
    } catch (e) {
      print('Error stopping player: $e');
      rethrow;
    }
  }

  bool get isRecorderInited => _mRecorderIsInited;
  bool get isPlaybackReady => _mplaybackReady;
  bool get isPlayerInited => _mPlayerIsInited;
  FlutterSoundPlayer? get player => _mPlayer;
  FlutterSoundRecorder? get recorder => _mRecorder;
}
