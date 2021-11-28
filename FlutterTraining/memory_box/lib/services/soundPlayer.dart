import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class SoundPlayer {
  // AudioPlayer? audioPlayer;
  FlutterSoundPlayer? _flutterSoundPlayer = FlutterSoundPlayer();
  late String pathToSaveAudio;
  late Directory appDirectory;

  bool isSoundPlay = false;
  bool _isPlayerInitialised = false;

  Duration? _soundDuration;
  int? get soundDuration => _soundDuration?.inMilliseconds;

  Future<void> init() async {
    await _openSoundSession().then(
      (_) => {
        _isPlayerInitialised = true,
      },
    );

    _soundDuration = await _flutterSoundPlayer!.startPlayer(
      fromURI: '/sdcard/download/test2.aac',
      codec: Codec.aacMP4,
    );
    _flutterSoundPlayer!.pausePlayer();

    appDirectory = await getApplicationDocumentsDirectory();
    pathToSaveAudio = appDirectory.path + '/' + 'Аудиозапись' + '.aac';
  }

  Future<void> dispose() async {
    if (isSoundPlay) {
      pause();
    }
    await _closeSoundSession();
    _flutterSoundPlayer = null;
    _isPlayerInitialised = false;
  }

  Future<void> _openSoundSession() async {
    await _flutterSoundPlayer?.openAudioSession();
  }

  Future<void> _closeSoundSession() async {
    if (_isPlayerInitialised) await _flutterSoundPlayer?.closeAudioSession();
  }

  void play() async {
    isSoundPlay = true;
    _flutterSoundPlayer?.resumePlayer();
  }

  void pause() {
    isSoundPlay = false;
    _flutterSoundPlayer?.pausePlayer();
  }

  void seek({required int playTimeInMS}) {
    _flutterSoundPlayer?.seekToPlayer(Duration(milliseconds: playTimeInMS));
  }

  void moveForward({required int playTimeInMS}) {
    _flutterSoundPlayer?.seekToPlayer(
      Duration(milliseconds: playTimeInMS + 15000),
    );
  }

  void moveBackward({required int playTimeInMS}) {
    _flutterSoundPlayer?.seekToPlayer(
      Duration(milliseconds: playTimeInMS - 15000),
    );
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
