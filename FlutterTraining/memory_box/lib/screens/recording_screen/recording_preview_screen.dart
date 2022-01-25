import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/blocks/bottom_navigation_index_control/bottom_navigation_index_control_cubit.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/screens/recording_screen/widgets/bottom_sheet_wrapper.dart';
import 'package:memory_box/screens/recording_screen/widgets/tale_controls_buttons.dart';
import 'package:memory_box/widgets/audioSlider.dart';

class RecordingPreviewScreen extends StatefulWidget {
  const RecordingPreviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  _RecordingPreviewScreenState createState() => _RecordingPreviewScreenState();
}

class _RecordingPreviewScreenState extends State<RecordingPreviewScreen> {
  final _textEditingController = TextEditingController();

  bool _isEditMode = false;
  String? audioLabel;

  AudioplayerBloc? _audioBloc;
  String? _pathToSaveAudio;

  @override
  void initState() {
    _audioBloc = BlocProvider.of<AudioplayerBloc>(context);

    audioLabel = _audioBloc?.state.taleModel.title;

    _textEditingController.text = audioLabel ?? '';
    changeRecordingButton();

    // _audioBloc?.add(
    //   InitPlayer(
    //     soundUrl: '/sdcard/download/test2.aac',
    //     soundTitle: widget.soundTitle,
    //   ),
    // );
    super.initState();
  }

  @override
  void dispose() {
    _audioBloc?.add(DisposePlayer());
    _textEditingController.dispose();
    super.dispose();
  }

  void closeWindow() {
    _audioBloc?.add(DisposePlayer());
    Navigator.of(context).pop();
  }

  void changeRecordingButton() {
    BlocProvider.of<BottomNavigationIndexControlCubit>(context).changeIcon(
      RecorderButtonStates.withIcon,
    );
  }

  void changeEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (_isEditMode) {
        audioLabel = _textEditingController.text;
      }
    });
  }

  void saveChanges() async {
    // String? ID = _audioBloc?.state.soundModel?.ID;
    // if (ID != null && audioLabel != null) {
    //   await DatabaseService.instance.updateTaleData(
    //     taleID: ID,
    //     title: _textEditingController.text,
    //   );
    // }
    changeEditMode();
  }

  void undoChanges() {
    setState(() {
      _textEditingController.text = audioLabel ?? '';
    });
    changeEditMode();
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

  @override
  Widget build(BuildContext context) {
    TextStyle popupMenuTextStyle = const TextStyle(
      fontFamily: 'TTNorms',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Colors.black,
    );

    TextStyle editMenuTextStyle = const TextStyle(
      fontFamily: 'TTNorms',
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: Colors.black,
    );

    return BottomSheetWrapeer(
      height: 640,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ),
        child: Column(
          children: [
            _isEditMode
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          undoChanges();
                        },
                        child: Text(
                          'Отменить',
                          style: editMenuTextStyle,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          saveChanges();
                        },
                        child: Text(
                          'Готово',
                          style: editMenuTextStyle,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          closeWindow();
                        },
                        icon: SvgPicture.asset(
                          AppIcons.hideCircle,
                        ),
                      ),
                      PopupMenuButton(
                        offset: const Offset(7, 15),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        onSelected: (_) {
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: SvgPicture.asset(
                            AppIcons.more,
                            color: Colors.black,
                          ),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "Добавить в подборку",
                                style: popupMenuTextStyle,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: changeEditMode,
                              child: Text(
                                "Редактировать название",
                                style: popupMenuTextStyle,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "Поделиться",
                                style: popupMenuTextStyle,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "Скачать",
                                style: popupMenuTextStyle,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "Удалить",
                                style: popupMenuTextStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              foregroundDecoration: _isEditMode
                  ? BoxDecoration(
                      color: Colors.grey.withOpacity(0.6),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                      // backgroundBlendMode: BlendMode.saturation,
                    )
                  : null,
              child: Image.asset(
                'assets/images/cover.png',
                width: 270,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              _isEditMode ? '' : 'Название подборки',
              style: TextStyle(
                color: _isEditMode ? Colors.grey : Colors.black,
                fontFamily: 'TTNorms',
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 60,
              ),
              child: TextField(
                controller: _textEditingController,
                enabled: _isEditMode ? true : false,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  fontFamily: 'TTNorms',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  isDense: true,
                  border: _isEditMode ? null : InputBorder.none,
                  disabledBorder: _isEditMode
                      ? const UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.black,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<AudioplayerBloc, AudioplayerState>(
                  builder: (context, state) {
                return AudioSlider(
                  onChanged: () {},
                  onChangeEnd: _onSlidedChangeEnd,
                  currentPlayDuration: state.currentPlayDuration,
                  taleDuration: state.taleModel.duration,
                );
              }),
            ),
            TaleControlButtons(
              tooglePlay: _tooglePlay,
              moveBackward: _moveBackward,
              moveForward: _moveForward,
            )
          ],
        ),
      ),
    );
  }
}
