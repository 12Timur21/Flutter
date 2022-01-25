import 'dart:async';
import 'dart:io';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:share/share.dart';

class SoundPlayer {
  SoundPlayer._();
  static final SoundPlayer instance = SoundPlayer._();

  FlutterSoundPlayer? _flutterSoundPlayer;

  bool get isSoundPlay => _flutterSoundPlayer?.isPlaying ?? false;

  Stream<PlaybackDisposition>? get soundDurationStream =>
      _flutterSoundPlayer?.onProgress;

  final StreamController<bool> _whenFinishedController =
      StreamController<bool>();
  Stream<bool>? get whenFinishedStream => _whenFinishedController.stream;

  Future<bool> initPlayer() async {
    try {
      _flutterSoundPlayer = FlutterSoundPlayer();
      await _flutterSoundPlayer?.openAudioSession(
        mode: SessionMode.modeMeasurement,
        focus: AudioFocus.requestFocus,
      );

      await _flutterSoundPlayer?.setSubscriptionDuration(
        const Duration(
          seconds: 1,
        ),
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Duration> initTale({
    required TaleModel taleModel,
    required bool isAutoPlay,
  }) async {
    Duration? taleDuration = await _flutterSoundPlayer?.startPlayer(
      fromURI: taleModel.url,
      codec: Codec.aacADTS,
      whenFinished: whenFinished,
    );

    if (!isAutoPlay) {
      await _flutterSoundPlayer?.pausePlayer();
    }
    return taleDuration ?? Duration.zero;
  }

  void whenFinished() {
    print('начало конца --------------------');
    _whenFinishedController.add(true);
  }

  Future<void> dispose() async {
    print('dispose');
    await _flutterSoundPlayer?.stopPlayer();

    await _flutterSoundPlayer?.closeAudioSession();
    _flutterSoundPlayer = null;

    _whenFinishedController.close();
  }

  Future<void> resumePlayer() async {
    _flutterSoundPlayer?.resumePlayer();
  }

  Future<void> pausePlayer() async {
    await _flutterSoundPlayer?.pausePlayer();
  }

  void seek({required Duration currentPlayTime}) {
    _flutterSoundPlayer?.seekToPlayer(currentPlayTime);
  }

  Future<Duration> moveForward15Sec({
    required Duration currentPlayDuration,
    required Duration taleDuration,
  }) async {
    Duration updatedDurationPosition = currentPlayDuration;

    if (currentPlayDuration.inSeconds + 15 <= taleDuration.inSeconds) {
      updatedDurationPosition = Duration(
        seconds: updatedDurationPosition.inSeconds + 15,
      );
    } else {
      updatedDurationPosition = Duration(
        seconds: taleDuration.inSeconds,
      );
    }
    await _flutterSoundPlayer?.seekToPlayer(updatedDurationPosition);
    return updatedDurationPosition;
  }

  Future<Duration> moveBackward15Sec({
    required Duration currentPlayDuration,
  }) async {
    Duration updatedDurationPosition = currentPlayDuration;
    if (currentPlayDuration.inSeconds - 15 >= 0) {
      updatedDurationPosition = Duration(
        seconds: updatedDurationPosition.inSeconds - 15,
      );
    } else {
      updatedDurationPosition = Duration.zero;
    }
    await _flutterSoundPlayer?.seekToPlayer(updatedDurationPosition);
    return updatedDurationPosition;
  }

  void localDownloadSound(String pathToSaveAudio) async {}
}
