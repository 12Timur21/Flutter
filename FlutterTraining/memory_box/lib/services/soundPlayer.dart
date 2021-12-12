import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class SoundPlayer {
  static final SoundPlayer _singleton = SoundPlayer._();
  factory SoundPlayer() {
    return _singleton;
  }
  SoundPlayer._();

  FlutterSoundPlayer? _flutterSoundPlayer;
  String? pathToSaveAudio;
  Directory? appDirectory;
  bool isSoundPlay = false;

  Stream<PlaybackDisposition>? get soundDurationStream =>
      _flutterSoundPlayer?.onProgress;

  Duration? _soundDuration;
  Duration get songDuration => _soundDuration ?? Duration.zero;

  Duration? _currentPlayDuration;
  Duration get currentPlayDuration => _currentPlayDuration ?? Duration.zero;

  Future<void> init({required String soundUrl}) async {
    _flutterSoundPlayer = FlutterSoundPlayer();
    await _openSoundSession();

    //
    _soundDuration = await _flutterSoundPlayer?.startPlayer(
      fromURI: soundUrl,
      codec: Codec.aacMP4,
      whenFinished: () {},
    );
    _flutterSoundPlayer?.pausePlayer();
    //

    setSubscriptionDuration(
      subscriptionDurationInSec: 1,
    );
    startProgressListener();
  }

  Future<void> dispose() async {
    await _closeSoundSession();
    await _flutterSoundPlayer?.stopPlayer();
    _flutterSoundPlayer = null;
  }

  Future<void> setSubscriptionDuration({
    required int subscriptionDurationInSec,
  }) async {
    await _flutterSoundPlayer?.setSubscriptionDuration(
      Duration(
        seconds: subscriptionDurationInSec,
      ),
    );
  }

  Future<FlutterSoundPlayer?> _openSoundSession() async {
    await _flutterSoundPlayer?.openAudioSession();
  }

  Future<void> _closeSoundSession() async {
    await _flutterSoundPlayer?.closeAudioSession();
  }

  void startProgressListener() {
    //!
    soundDurationStream?.listen((e) {
      // maxDuration = e.duration;
      _currentPlayDuration = e.position;
    });
  }

  Future<void> play() async {
    await _flutterSoundPlayer?.resumePlayer();
    isSoundPlay = true;
  }

  Future<void> pause() async {
    await _flutterSoundPlayer?.pausePlayer();
    isSoundPlay = false;
  }

  void seek({required int currentPlayTimeInSec}) {
    _flutterSoundPlayer?.seekToPlayer(Duration(
      seconds: currentPlayTimeInSec,
    ));
  }

  void moveForward15Sec({required int currentPlayTimeInSec}) {
    if (currentPlayTimeInSec + 15 <= songDuration.inSeconds) {
      _flutterSoundPlayer?.seekToPlayer(
        Duration(
          seconds: currentPlayTimeInSec + 15,
        ),
      );
    } else {
      _flutterSoundPlayer?.seekToPlayer(
        Duration(
          seconds: songDuration.inSeconds,
        ),
      );
    }
  }

  void moveBackward15Sec({required int currentPlayTimeInSec}) {
    if (currentPlayTimeInSec - 15 >= 0) {
      _flutterSoundPlayer?.seekToPlayer(
        Duration(
          seconds: currentPlayTimeInSec - 15,
        ),
      );
    } else {
      _flutterSoundPlayer?.seekToPlayer(Duration.zero);
    }
  }

  void shareSound(String pathToSaveAudio) {
    Share.shareFiles([pathToSaveAudio]);
  }

  void localDownloadSound(String pathToSaveAudio) async {
    String downloadDirectory = '';

    //?
    if (Platform.isAndroid) {
      downloadDirectory = '/sdcard/download/Аудиозапись.aac';
    }

    File pathToAudio = File(pathToSaveAudio);

    try {
      await pathToAudio.rename(downloadDirectory);
    } on FileSystemException catch (e) {
      await pathToAudio.copy(downloadDirectory);
      deleteSound();
    }
  }

  void deleteSound() {
    // appDirectory?.deleteSync(recursive: true);
  }
}
