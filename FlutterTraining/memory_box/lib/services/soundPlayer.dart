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

  // AudioPlayer? audioPlayer;
  FlutterSoundPlayer? _flutterSoundPlayer;
  late String pathToSaveAudio;
  late Directory appDirectory;

  bool isSoundPlay = false;
  bool _isPlayerInitialised = false;

  // Duration? _soundDuration;
  // int? get soundDuration => _soundDuration?.inMilliseconds;

  Stream<PlaybackDisposition>? get soundDurationStream =>
      _flutterSoundPlayer?.onProgress?.asBroadcastStream();

  Duration? _maxDuration;
  Duration get maxDuration => _maxDuration ?? Duration.zero;

  Duration? _position;
  Duration get position => _position ?? Duration.zero;

  Future<void> init({
    required String soundUrl,
    int? subscriptionDuration,
  }) async {
    _flutterSoundPlayer = FlutterSoundPlayer();
    await _openSoundSession();
    _isPlayerInitialised = true;

    _maxDuration = await _flutterSoundPlayer?.startPlayer(
      fromURI: soundUrl,
      codec: Codec.aacMP4,
      whenFinished: onFinished,
    );
    _flutterSoundPlayer?.pausePlayer();

    _flutterSoundPlayer?.setSubscriptionDuration(
      Duration(
        seconds: subscriptionDuration ?? 1,
      ),
    );

    startProgressListener();
  }

  // String get appDirectory = await getApplicationDocumentsDirectory();
  //   pathToSaveAudio = appDirectory.path + '/' + 'Аудиозапись' + '.aac';

  //!
  void onFinished() {
    print('finished');
  }

  Future<void> dispose() async {
    if (isSoundPlay) {
      pause();
    }
    await _closeSoundSession();
    _isPlayerInitialised = false;
  }

  Future<FlutterSoundPlayer?> _openSoundSession() async {
    await _flutterSoundPlayer?.openAudioSession();
  }

  Future<void> _closeSoundSession() async {
    if (_isPlayerInitialised) await _flutterSoundPlayer?.closeAudioSession();
  }

  void startProgressListener() {
    soundDurationStream?.listen((e) {
      // maxDuration = e.duration;
      _position = e.position;
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

  void seek({required int playTimeInMS}) {
    _flutterSoundPlayer?.seekToPlayer(Duration(
      milliseconds: playTimeInMS,
    ));
  }

  void moveForward() {
    if (position.inSeconds + 15 <= maxDuration.inSeconds) {
      _flutterSoundPlayer?.seekToPlayer(
        Duration(
          seconds: position.inSeconds + 15,
        ),
      );
    } else {
      _flutterSoundPlayer?.seekToPlayer(
        Duration(
          seconds: maxDuration.inSeconds,
        ),
      );
    }
  }

  void moveBackward() {
    if (position.inSeconds - 15 >= 0) {
      _flutterSoundPlayer?.seekToPlayer(
        Duration(
          seconds: position.inSeconds - 15,
        ),
      );
    } else {
      _flutterSoundPlayer?.seekToPlayer(Duration.zero);
    }
  }

  void shareSound() {
    Share.shareFiles([pathToSaveAudio]);
  }

  void localDownloadSound() async {
    String downloadDirectory = '';

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
    appDirectory.deleteSync(recursive: true);
  }
}
