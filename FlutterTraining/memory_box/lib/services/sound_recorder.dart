import 'dart:async';
import 'dart:developer';

import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';

import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  final String pathToSaveAudio = 'audio_example.aac';
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialised = false;

  Future<bool?> init() async {
    _audioRecorder = FlutterSoundRecorder();
    _isRecorderInitialised = true;

    bool isGranted = await _checkPermission();
    if (isGranted) {
      await _openRecorderAudioSession();
      _setAudioRecorderSubscriptionDuration(
        const Duration(
          milliseconds: 20,
        ),
      );
      log('recorder session open');
      return true;
    }

    return null;
  }

  void dispose() {
    if (!_isRecorderInitialised) return;
    _closeRecorderAudioSession();
    _audioRecorder = null;
    _isRecorderInitialised = false;
  }

  void startRecording() async {
    if (!_isRecorderInitialised) return;
    await _audioRecorder!.startRecorder(
      toFile: pathToSaveAudio,
    );
  }

  void finishRecording() async {
    if (!_isRecorderInitialised) return;
    await _audioRecorder!.stopRecorder();
    dispose();
  }

  Stream<RecordingDisposition>? get recorderStream =>
      _audioRecorder!.onProgress!.asBroadcastStream();

  Future<void> _openRecorderAudioSession() async {
    await _audioRecorder!.openAudioSession();
  }

  Future<void> _closeRecorderAudioSession() async {
    await _audioRecorder?.closeAudioSession();
  }

  Future<void> _setAudioRecorderSubscriptionDuration(Duration duration) async {
    await _audioRecorder!.setSubscriptionDuration(duration);
  }

  Future<bool> _checkPermission() async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.storage,
      Permission.microphone,
    ].request();

    bool isGranted = permissions[Permission.storage]!.isGranted &&
        permissions[Permission.microphone]!.isGranted;

    if (isGranted) {
      return true;
    } else {
      throw RecordingPermissionException('Microphone permission denied');
    }
  }
}
