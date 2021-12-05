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
import 'package:memory_box/services/cloudService.dart';
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
  String fileName = 'Запись №';

  @override
  void initState() {
    asyncInit();
    final _audioBloc = BlocProvider.of<AudioplayerBloc>(context);
    _audioBloc.add(
      InitPlayer(
        title: 'song',
        soundUrl: '/sdcard/download/test2.aac',
      ),
    );
    changeRecordingButton();
    super.initState();
  }

  void asyncInit() async {
    final _audioBloc = BlocProvider.of<AuthenticationBloc>(context);
    Authenticated authenticated = _audioBloc.state as Authenticated;

    if (authenticated.user.uid != null) {
      int index = await CloudService.instance.filesLength(
        fileType: FileType.sound,
        uid: authenticated.user.uid!,
      );
      setState(() {
        fileName = 'Запись №$index';
      });
    }
  }

  @override
  void dispose() {
    final _audioBloc = BlocProvider.of<AudioplayerBloc>(context);
    _audioBloc.add(DisposePlayer());
    super.dispose();
  }

  void shareSound() {
    final _audioBloc = BlocProvider.of<AudioplayerBloc>(context);
    _audioBloc.add(UpdatePlayDuration());
    print(_audioBloc.state.currentPlayDuration?.inMilliseconds);
    print(_audioBloc.state.songDuration?.inMilliseconds);
    _audioBloc.add(Seek());

    // _soundPlayer?.shareSound();
  }

  void localDownloadSound() {
    // _soundPlayer?.localDownloadSound();
  }

  void deleteSound() async {
    final _audioBloc = BlocProvider.of<AuthenticationBloc>(context);
    Authenticated authenticated = _audioBloc.state as Authenticated;

    var z = await CloudService.instance.getFileUrl(
      fileType: FileType.sound,
      uid: authenticated.user.uid!,
    );
    print(z);
    // await CloudService.instance.filesLength(fileType: FileType.sound);
    // bool? isDelete = await showDialog<bool>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return const DeleteAlert();
    //   },
    // );
    // if (isDelete == true) {
    //   _soundPlayer?.deleteSound();
    //   Navigator.of(context).pop();
    // }
  }

  void saveSound() async {
    final _audioBloc = BlocProvider.of<AuthenticationBloc>(context);
    Authenticated authenticated = _audioBloc.state as Authenticated;

    if (authenticated.user.uid != null) {
      final file = File('/sdcard/download/test2.aac');

      await CloudService.instance.uploadFile(
        file: file,
        fileName: 'test2.aac',
        fileType: FileType.sound,
        uid: authenticated.user.uid!,
      );
      navigateToPreviewPage();
    }
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
    if (_audioBloc.state.isPlay) {
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
    return BlocBuilder<AudioplayerBloc, AudioplayerState>(
      builder: (context, state) {
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
                            icon: SvgPicture.asset(
                                'assets/icons/PaperDownload.svg'),
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
                  child: AudioSlider(),
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
      },
    );
  }
}
