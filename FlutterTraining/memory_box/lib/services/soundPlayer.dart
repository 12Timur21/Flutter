import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class SoundPlayer {
  AudioPlayer? audioPlayer;
  late Directory appDirectory;
  late String pathToSaveAudio;
  bool isSoundPlay = false;

  Future<void> init() async {
    audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    // appDirectory = await getApplicationDocumentsDirectory();
    // pathToSaveAudio = appDirectory.path + '/' + 'Аудиозапись' + '.aac';
    await audioPlayer?.setUrl('/sdcard/download/test2.aac', isLocal: true);

    print('first steep');
    Future.delayed(
      Duration(seconds: 4),
      () async {
        print(
          await audioPlayer?.getDuration(),
        );
      },
    );
    // audioPlayer?.
    // audioPlayer!.getDuration().then((value) => print(value));
    // audioPlayer!.onAudioPositionChanged.listen((event) {
    //   print(event.inSeconds);
    // });
    // audioPlayer!.getCurrentPosition().then((value) => log(value.toString()));
    // audioPlayer!.seek(position)
  }

  Future<void> dispose() async {
    await audioPlayer?.stop();
    await audioPlayer?.release();
    await audioPlayer?.dispose();
    audioPlayer = null;
  }

  Future<int>? get audioDurationInMs => audioPlayer?.getDuration();

  void playLocal() async {
    audioPlayer?.resume();
    isSoundPlay = true;
  }

  void pauseLocal() async {
    int result = await audioPlayer!.pause();
    isSoundPlay = false;
  }

  void moveBack() {}

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
