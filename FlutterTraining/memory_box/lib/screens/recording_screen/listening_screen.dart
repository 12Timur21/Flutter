import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_bloc.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_event.dart';
import 'package:memory_box/blocks/bottom_navigation_index_control/bottom_navigation_index_control_cubit.dart';

import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/storage_service.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/screens/recording_screen/widgets/bottom_sheet_wrapper.dart';
import 'package:memory_box/screens/recording_screen/widgets/tale_controls_buttons.dart';
import 'package:memory_box/widgets/audioSlider.dart';
import 'package:memory_box/widgets/deleteAlert.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class ListeningScreen extends StatefulWidget {
  static const routeName = 'ListeningScreen';

  const ListeningScreen({Key? key}) : super(key: key);
  @override
  _ListeningScreenState createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  AudioplayerBloc? _audioBloc;

  String? _pathToSaveAudio;

  @override
  void initState() {
    _audioBloc = BlocProvider.of<AudioplayerBloc>(context);

    _changeRecordingButton();
    asyncInit();

    super.initState();
  }

  @override
  void dispose() {
    // _audioBloc?.add(
    //   DisposePlayer(),
    // );
    super.dispose();
  }

  void asyncInit() async {
    // appDirectory = await getApplicationDocumentsDirectory();
    Directory? appDirectory = Directory('/storage/emulated/0/Download');
    // pathToSaveAudio = appDirectory!.path + '/' + 'Аудиозапись' + '.aac';

    _pathToSaveAudio = appDirectory.path + '/' + 'test2' + '.aac';
    TaleModel _taleModel = TaleModel(
      url: _pathToSaveAudio,
      ID: const Uuid().v4(),
    );

    _audioBloc?.add(InitPlayer());
    _audioBloc?.add(
      InitTale(
        taleModel: _taleModel,
        isAutoPlay: false,
      ),
    );
    _audioBloc?.add(
      Pause(),
    );

    int index = await StorageService.instance.filesLength(
      fileType: FileType.tale,
    );

    //!Через навигацию

    _audioBloc?.add(
      UpdateTaleModel(
        'Запись №$index',
      ),
    );
  }

  void _tooglePlay() {
    bool? isPlay = _audioBloc?.state.isPlay;
    if (isPlay == true) {
      _audioBloc?.add(
        Pause(),
      );
    } else {
      _audioBloc?.add(
        Play(
          taleModel: _audioBloc!.state.taleModel,
        ),
      );
    }
  }

  void _shareSound() {
    Share.shareFiles([_pathToSaveAudio!]);
  }

  void _changeRecordingButton() {
    BlocProvider.of<BottomNavigationIndexControlCubit>(context).changeIcon(
      RecorderButtonStates.defaultIcon,
    );
  }

  void _localDownloadSound() async {
    String downloadDirectory = '';

    if (Platform.isAndroid) {
      downloadDirectory = '/sdcard/download/test2123.aac';
    }

    File pathToAudio = File(_pathToSaveAudio!);

    try {
      await pathToAudio.rename(downloadDirectory);
    } on FileSystemException catch (_) {
      await pathToAudio.copy(downloadDirectory);
      Directory(_pathToSaveAudio!).deleteSync(recursive: true);
    }
  }

  void _deleteSound() async {
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
      Directory(_pathToSaveAudio!).deleteSync(recursive: true);
      _audioBloc?.add(DisposePlayer());
      Navigator.of(context).pop();
    }
  }

  void _navigateToPreviewPage() {
    BlocProvider.of<BottomSheetBloc>(context).add(
      OpenPreviewPage(),
    );
  }

  void _saveSound() async {
    final file = File(_pathToSaveAudio!);

    TaleModel? taleModel = _audioBloc?.state.taleModel;
    if (taleModel != null) {
      await StorageService.instance.uploadTaleFIle(
        file: file,
        duration: taleModel.duration ?? Duration.zero,
        taleID: taleModel.ID ?? '',
        title: taleModel.title ?? '',
      );
    }

    _navigateToPreviewPage();
  }

  void _moveBackward() {
    _audioBloc?.add(
      MoveBackward15Sec(),
    );
  }

  void _moveForward() {
    _audioBloc?.add(
      MoveForward15Sec(),
    );
  }

  void _onSlidedChangeEnd(double value) {
    _audioBloc?.add(
      Seek(currentPlayTimeInSec: value),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                Row(
                  children: [
                    IconButton(
                      padding: const EdgeInsets.only(right: 20),
                      onPressed: _shareSound,
                      icon: SvgPicture.asset(
                        AppIcons.share,
                      ),
                    ),
                    IconButton(
                      onPressed: _localDownloadSound,
                      icon: SvgPicture.asset(
                        AppIcons.paperDownload,
                      ),
                    ),
                    IconButton(
                      padding: const EdgeInsets.only(left: 20),
                      onPressed: _deleteSound,
                      icon: SvgPicture.asset(
                        AppIcons.delete,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _saveSound,
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
            Expanded(
              child: BlocBuilder<AudioplayerBloc, AudioplayerState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Text(
                        state.taleModel.title ?? 'Запись №',
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
                      AudioSlider(
                        onChanged: () {},
                        onChangeEnd: _onSlidedChangeEnd,
                        currentPlayDuration: state.currentPlayDuration,
                        taleDuration: state.taleModel.duration,
                      ),
                      TaleControlButtons(
                        tooglePlay: _tooglePlay,
                        moveBackward: _moveBackward,
                        moveForward: _moveForward,
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
