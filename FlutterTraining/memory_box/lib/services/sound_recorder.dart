import 'dart:async';
import 'dart:developer';

import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';

import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  final String pathToSaveAudio = 'audio_example.aac';

  FlutterSoundRecorder? _soundRecorder;
  bool _isRecorderInitialised = false;

  Future<void> init() async {
    try {
      bool isPermissionsReceived = await _checkPermission();
      if (isPermissionsReceived) {
        _isRecorderInitialised = true;
        _soundRecorder = FlutterSoundRecorder();

        await _openRecorderAudioSession();
        _setAudioRecorderSubscriptionDuration(
          const Duration(
            milliseconds: 20,
          ),
        );
        log('Recorder session open');
      }
    } catch (e) {
      dispose();
      log('Failed to open recorder session ');
    }
  }

  void dispose() {
    if (!_isRecorderInitialised) return;
    _closeRecorderAudioSession();
    _soundRecorder = null;
    _isRecorderInitialised = false;
  }

  void startRecording() async {
    if (!_isRecorderInitialised) return;
    await _soundRecorder?.startRecorder(
      toFile: pathToSaveAudio,
    );
  }

  void finishRecording() async {
    if (!_isRecorderInitialised) return;
    await _soundRecorder?.stopRecorder();
    dispose();
  }

  Stream<RecordingDisposition>? get recorderStream {
    if (!_isRecorderInitialised) {
      return null;
    }
    return _soundRecorder?.onProgress;
  }

  Future<void> _openRecorderAudioSession() async {
    await _soundRecorder?.openAudioSession();
  }

  Future<void> _closeRecorderAudioSession() async {
    await _soundRecorder?.closeAudioSession();
  }

  Future<void> _setAudioRecorderSubscriptionDuration(Duration duration) async {
    await _soundRecorder?.setSubscriptionDuration(duration);
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
      return false;
      // throw RecordingPermissionException('Permission denied');
    }
  }
}
