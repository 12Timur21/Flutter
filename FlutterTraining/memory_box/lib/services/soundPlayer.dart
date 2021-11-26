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

  void init() async {
    audioPlayer = AudioPlayer();
    appDirectory = await getApplicationDocumentsDirectory();
    pathToSaveAudio = appDirectory.path + '/' + 'Аудиозапись' + '.aac';
    // audioPlayer!.getDuration().then((value) => print(value));
    // audioPlayer!.onAudioPositionChanged.listen((event) {
    //   print(event.inSeconds);
    // });
    // audioPlayer!.getCurrentPosition().then((value) => log(value.toString()));
    // audioPlayer!.seek(position)
  }

  void playLocal() async {
    int result = await audioPlayer!.play(pathToSaveAudio, isLocal: true);
    isSoundPlay = true;
  }

  void pauseLocal() async {
    int result = await audioPlayer!.pause();
    isSoundPlay = false;
  }

  void moveForward() {
    // int result =  await audioPlayer!.seek()
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
