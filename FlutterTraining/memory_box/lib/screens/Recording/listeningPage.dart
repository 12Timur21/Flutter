import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/blocks/authentication/authentication_bloc.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_bloc.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_event.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_state.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton._event.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_bloc.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_state.dart';
import 'package:memory_box/repositories/storageService.dart';
import 'package:memory_box/widgets/audioSlider.dart';
import 'package:memory_box/widgets/bottomSheetWrapper.dart';
import 'package:memory_box/widgets/deleteAlert.dart';
import 'package:memory_box/widgets/soundControlsButtons.dart';

class ListeningPage extends StatefulWidget {
  static const routeName = 'ListeningPage';

  const ListeningPage({Key? key}) : super(key: key);
  @override
  _ListeningPageState createState() => _ListeningPageState();
}

class _ListeningPageState extends State<ListeningPage> {
  String fileName = 'Запись №_';
  late final AudioplayerBloc _audioBloc;

  @override
  void initState() {
    asyncInit();
    _audioBloc = BlocProvider.of<AudioplayerBloc>(context);

    // appDirectory = await getApplicationDocumentsDirectory();
    // pathToSaveAudio = appDirectory.path + '/' + 'Аудиозапись' + '.aac';

    _audioBloc.add(
      InitPlayer(
        soundUrl: '/sdcard/download/test2.aac',
      ),
    );
    changeRecordingButton();
    super.initState();
  }

  void asyncInit() async {
    final _authBloc = BlocProvider.of<AuthenticationBloc>(context).state;
    String? uid = _authBloc.user?.uid;

    if (uid != null) {
      int index = await StorageService.instance.filesLength(
        fileType: FileType.sound,
        uid: uid,
      );
      setState(() {
        fileName = 'Запись №$index';
        _audioBloc.add(UpdateSoundTitle(fileName));
      });
    }
  }

  @override
  void dispose() {
    _audioBloc.add(DisposePlayer());
    super.dispose();
  }

  void shareSound() {}

  void localDownloadSound() {
    // _soundPlayer?.localDownloadSound();
  }

  void deleteSound() async {
    final _audioBloc = BlocProvider.of<AudioplayerBloc>(context);

    bool? isDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const DeleteAlert(
          title: 'Удалить эту аудиозапись?',
          content: 'Вы действительно хотите удалить аудиозапись?',
        );
      },
    );
    if (isDelete == true) {
      _audioBloc.add(DeleteSound());
      Navigator.of(context).pop();
    }
  }

  void saveSound() async {
    final user = BlocProvider.of<AuthenticationBloc>(context).state;
    final String? uid = user.user?.uid;

    if (uid != null) {
      final file = File('sdcard/download/test2.aac');
      await StorageService.instance.uploadFile(
        file: file,
        fileName: 'test2.aac',
        fileType: FileType.sound,
        uid: uid,
      );
      // navigateToPreviewPage();
    }
    //!!!!
    // await CloudService.instance.isFileExist(
    //   fileType: FileType.sound,
    //   fileName: 'test2.aac',
    // );

    // dispose();
    // Navigator.of(context).pop();
  }

  void moveBackward() {
    final _audioBloc = BlocProvider.of<AudioplayerBloc>(context);
    _audioBloc.add(MoveBackward15Sec());
  }

  void moveForward() {
    final _audioBloc = BlocProvider.of<AudioplayerBloc>(context);
    _audioBloc.add(MoveBackward15Sec());
  }

  void tooglePlay() {
    final _audioBloc = BlocProvider.of<AudioplayerBloc>(context);
    bool? isPlay = _audioBloc.state.isPlay;
    if (isPlay == true) {
      _audioBloc.add(
        Pause(),
      );
    } else {
      _audioBloc.add(
        Play(),
      );
    }
  }

  void changeRecordingButton() {
    final recorderButtomBloc = BlocProvider.of<RecorderButtomBloc>(context);
    recorderButtomBloc.add(
      ChangeIcon(
        RecorderButtonStates.Default,
      ),
    );
  }

  void navigateToPreviewPage() {
    dispose();
    final navigationBloc = BlocProvider.of<BottomSheetBloc>(context);
    navigationBloc.add(
      OpenListeningPage(
        BottomSheetItems.PreviewRecord,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _audioBloc = BlocProvider.of<AudioplayerBloc>(context);

    return BottomSheetWrapeer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      IconButton(
                        padding: const EdgeInsets.only(right: 20),
                        onPressed: shareSound,
                        icon: SvgPicture.asset('assets/icons/Share.svg'),
                      ),
                      IconButton(
                        onPressed: localDownloadSound,
                        icon:
                            SvgPicture.asset('assets/icons/PaperDownload.svg'),
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(left: 20),
                        onPressed: deleteSound,
                        icon: SvgPicture.asset('assets/icons/Delete.svg'),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: saveSound,
                  child: const Text(
                    'Сохранить',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 90,
            ),
            Text(
              fileName,
              style: const TextStyle(
                fontFamily: 'TTNorms',
                fontWeight: FontWeight.w500,
                fontSize: 24,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: BlocBuilder<AudioplayerBloc, AudioplayerState>(
                  builder: (context, state) {
                return AudioSlider(
                  onChanged: () {
                    if (state.isPlay == true) {
                      _audioBloc.add(StopTimer());
                    }
                  },
                  onChangeEnd: (double value) {
                    _audioBloc.add(
                      Seek(currentPlayTimeInSec: value),
                    );

                    if (state.isPlay == true) {
                      _audioBloc.add(StartTimer());
                    }
                  },
                  currentPlayDuration: state.currentPlayDuration,
                  soundDuration: state.songDuration,
                );
              }),
            ),
            SoundControlButtons(
              tooglePlay: tooglePlay,
              moveBackward: moveBackward,
              moveForward: moveForward,
            )
          ],
        ),
      ),
    );
  }
}
