import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  String? pathToSaveAudio;

  FlutterSoundRecorder? _soundRecorder;

  bool _isRecorderInitialised = false;

  Future<void> init() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    pathToSaveAudio = appDirectory.path + '/' + 'Аудиозапись' + '.aac';
    try {
      bool isPermissionsReceived = await _checkPermission();
      if (isPermissionsReceived) {
        _soundRecorder = FlutterSoundRecorder();
        _isRecorderInitialised = true;
        await _soundRecorder?.openAudioSession();
        await _soundRecorder?.setSubscriptionDuration(
          const Duration(
            milliseconds: 20,
          ),
        );
      }
    } catch (e) {
      dispose();
      log('Failed to open recorder session ');
    }
  }

  Future<void> dispose() async {
    if (_isRecorderInitialised) {
      await _soundRecorder?.closeAudioSession();
      _soundRecorder = null;
    }
  }

  Future<void> startRecording() async {
    if (_isRecorderInitialised) {
      await _soundRecorder?.startRecorder(
        toFile: pathToSaveAudio,
      );
    }
  }

  Future<void> finishRecording() async {
    if (_isRecorderInitialised) {
      await _soundRecorder?.stopRecorder();
      await dispose();
    }
  }

  Stream<RecordingDisposition>? get recorderStream {
    if (_isRecorderInitialised) {
      return _soundRecorder?.onProgress;
    }
  }

  Future<bool> _checkPermission() async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.storage,
      Permission.microphone,
    ].request();
    // Permiti
    bool isGranted = permissions[Permission.storage]!.isGranted &&
        permissions[Permission.microphone]!.isGranted;

    if (isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
