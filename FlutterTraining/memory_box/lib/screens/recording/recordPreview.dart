import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton._event.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_bloc.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_state.dart';
import 'package:memory_box/services/soundPlayer.dart';
import 'package:memory_box/widgets/audioSlider.dart';
import 'package:memory_box/widgets/bottomSheetWrapper.dart';
import 'package:memory_box/widgets/soundControlsButtons.dart';

class RecordPreview extends StatefulWidget {
  const RecordPreview({Key? key}) : super(key: key);

  @override
  _RecordPreviewState createState() => _RecordPreviewState();
}

class _RecordPreviewState extends State<RecordPreview> {
  final String soundName = 'Аудиозапись 1';

  SoundPlayer? _soundPlayer;

  final _textEditingController = TextEditingController();

  bool _isEditMode = false;
  String audioLabel = 'Название подборки';

  @override
  void initState() {
    _soundPlayer = SoundPlayer();
    //! _soundPlayer?.init();
    _textEditingController.text = 'Название аудиозаписи';
    changeRecordingButton();
    super.initState();
  }

  @override
  void dispose() {
    _soundPlayer?.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void closeWindow() {
    Navigator.of(context).pop();
  }

  void changeRecordingButton() {
    final recorderButtomBloc = BlocProvider.of<RecorderButtomBloc>(context);
    recorderButtomBloc.add(
      ChangeIcon(
        RecorderButtonStates.WithIcon,
      ),
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

  void saveChanges() {
    changeEditMode();
  }

  void undoChanges() {
    setState(() {
      _textEditingController.text = audioLabel;
    });
    changeEditMode();
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
          horizontal: 10,
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
                          'assets/icons/ArrowCircle.svg',
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
                            'assets/icons/More.svg',
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
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
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
            SizedBox(
              height: 15,
            ),
            Text(
              'Название подборки',
              style: TextStyle(
                color: _isEditMode ? Colors.grey : Colors.black,
                fontFamily: 'TTNorms',
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
            SizedBox(
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
                  hintStyle: TextStyle(
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
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                // child: AudioSlider(),
              ),
            ),
            // const SoundControlButtons()
          ],
        ),
      ),
    );
  }
}
