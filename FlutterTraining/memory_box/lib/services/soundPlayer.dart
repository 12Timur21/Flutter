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

  // String? pathToSaveAudio;
  // Directory? appDirectory;
  // bool isSoundPlay = false;

  Stream<PlaybackDisposition>? get soundDurationStream =>
      _flutterSoundPlayer?.onProgress;

  // StreamSubscription? soundDurationStreamController;

  // Duration? _soundDuration;
  // Duration get songDuration => _soundDuration ?? Duration.zero;

  // Duration? _currentPlayDuration;
  // Duration get currentPlayDuration => _currentPlayDuration ?? Duration.zero;

  Future<bool> initPlayer() async {
    try {
      _flutterSoundPlayer = FlutterSoundPlayer();
      await _flutterSoundPlayer?.openAudioSession();

      await _flutterSoundPlayer?.setSubscriptionDuration(
        const Duration(
          seconds: 1,
        ),
      );

      return true;
    } catch (_) {
      return false;
    }

    // await _openSoundSession();

    // //
    // _soundDuration = await _flutterSoundPlayer?.startPlayer(
    //   fromURI: soundUrl,
    //   codec: Codec.aacMP4,
    //   whenFinished: () {},
    // );
    // _flutterSoundPlayer?.pausePlayer();
    // //

    // setSubscriptionDuration(
    //   subscriptionDurationInSec: 1,
    // );
    // startProgressListener();
  }

  Future<Duration?> initTale({required TaleModel taleModel}) async {
    return await _flutterSoundPlayer?.startPlayer(
      fromURI: taleModel.url,
      codec: Codec.mp3,
      whenFinished: () {
        print('finished sound');
      },
    );
  }

  Future<void> dispose() async {
    await _flutterSoundPlayer?.stopPlayer();
    await _flutterSoundPlayer?.closeAudioSession();
    _flutterSoundPlayer = null;
    // soundDurationStreamController?.cancel();
  }

  Future<void> resumePlayer() async {
    _flutterSoundPlayer?.resumePlayer();
  }

  Future<void> pausePlayer() async {
    await _flutterSoundPlayer?.pausePlayer();
  }

  // Future<void> resumePlayer() async {
  //   await _flutterSoundPlayer?.resumePlayer();
  // }

  // Future<void> setSubscriptionDuration({
  //   required int subscriptionDurationInSec,
  // }) async {

  // }

  // void startProgressListener() {
  //   //!

  // }

  // Future<void> play() async {
  //   await _flutterSoundPlayer?.resumePlayer();
  //   isSoundPlay = true;
  // }

  // Future<void> pause() async {
  //   await _flutterSoundPlayer?.pausePlayer();
  //   isSoundPlay = false;
  // }

  // void seek({required int currentPlayTimeInSec}) {
  //   _flutterSoundPlayer?.seekToPlayer(Duration(
  //     seconds: currentPlayTimeInSec,
  //   ));
  // }

  // void moveForward15Sec({required int currentPlayTimeInSec}) {
  //   if (currentPlayTimeInSec + 15 <= songDuration.inSeconds) {
  //     _flutterSoundPlayer?.seekToPlayer(
  //       Duration(
  //         seconds: currentPlayTimeInSec + 15,
  //       ),
  //     );
  //   } else {
  //     _flutterSoundPlayer?.seekToPlayer(
  //       Duration(
  //         seconds: songDuration.inSeconds,
  //       ),
  //     );
  //   }
  // }

  // void moveBackward15Sec({required int currentPlayTimeInSec}) {
  //   if (currentPlayTimeInSec - 15 >= 0) {
  //     _flutterSoundPlayer?.seekToPlayer(
  //       Duration(
  //         seconds: currentPlayTimeInSec - 15,
  //       ),
  //     );
  //   } else {
  //     _flutterSoundPlayer?.seekToPlayer(Duration.zero);
  //   }
  // }

  // void shareSound(String pathToSaveAudio) {
  //   Share.shareFiles([pathToSaveAudio]);
  // }

  // void localDownloadSound(String pathToSaveAudio) async {
  //   String downloadDirectory = '';

  //   if (Platform.isAndroid) {
  //     downloadDirectory = '/sdcard/download/Аудиозапись.aac';
  //   }

  //   File pathToAudio = File(pathToSaveAudio);

  //   try {
  //     await pathToAudio.rename(downloadDirectory);
  //   } on FileSystemException catch (e) {
  //     await pathToAudio.copy(downloadDirectory);
  //     deleteSound();
  //   }
  // }

  // void deleteSound() {
  //   appDirectory?.deleteSync(recursive: true);
  // }
}
