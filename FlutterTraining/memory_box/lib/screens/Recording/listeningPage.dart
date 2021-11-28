import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton._event.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_bloc.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_state.dart';
import 'package:memory_box/services/soundPlayer.dart';
import 'package:memory_box/utils/formatting.dart';
import 'package:memory_box/widgets/bottomSheetWrapper.dart';
import 'package:memory_box/widgets/deleteAlert.dart';

class ListeningPage extends StatefulWidget {
  static const routeName = 'ListeningPage';

  const ListeningPage({Key? key}) : super(key: key);
  @override
  _ListeningPageState createState() => _ListeningPageState();
}

class _ListeningPageState extends State<ListeningPage> {
  final String soundName = 'Аудиозапись 1';
  bool isPlayMode = false;

  SoundPlayer? _soundPlayer;
  int _soundDuration = 0;
  int _currentPlayTime = 0;

  Timer? timerController;

  @override
  void initState() {
    _soundPlayer = SoundPlayer();
    changeRecordingButton();
    initAudioPlayer();
    super.initState();
  }

  void initAudioPlayer() async {
    await _soundPlayer?.init();
    setState(() {
      _soundDuration = _soundPlayer?.soundDuration ?? 0;
    });
  }

  @override
  void dispose() {
    _soundPlayer?.dispose();
    timerController?.cancel();
    super.dispose();
  }

  void shareSound() {
    _soundPlayer?.shareSound();
  }

  void localDownloadSound() {
    _soundPlayer?.localDownloadSound();
  }

  void deleteSound() async {
    bool? isDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const DeleteAlert();
      },
    );
    if (isDelete == true) {
      _soundPlayer?.deleteSound();
      Navigator.of(context).pop();
    }
  }

  void saveSound() {
    Navigator.of(context).pop();
  }

  void playSound() {
    _soundPlayer?.play();
    startTimer();
  }

  void pauseSound() {
    _soundPlayer?.pause();
    stopTimer();
  }

  void tooglePlay() {
    setState(() {
      isPlayMode = !isPlayMode;
      if (isPlayMode) {
        playSound();
      } else {
        pauseSound();
      }
    });
  }

  void seek(int currentPlayTime) {
    if (_currentPlayTime < 0) {
      _currentPlayTime = 0;
    }
    if (_currentPlayTime >= _soundDuration) {
      _currentPlayTime = _soundDuration;
    }
    _soundPlayer?.seek(playTimeInMS: _currentPlayTime);
  }

  void moveForward() {
    setState(() {
      _currentPlayTime += 15000;
      seek(_currentPlayTime);
    });
  }

  void moveBackward() {
    setState(() {
      _currentPlayTime -= 15000;
      seek(_currentPlayTime);
    });
  }

  void changeRecordingButton() {
    final recorderButtomBloc = BlocProvider.of<RecorderButtomBloc>(context);
    recorderButtomBloc.add(
      ChangeIcon(
        RecorderButtonStates.Default,
      ),
    );
  }

  void startTimer() {
    timerController = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _currentPlayTime += 1000;
        if (_currentPlayTime >= _soundDuration) {
          timerController?.cancel();
          _currentPlayTime = _soundDuration;
        }
      });
    });
  }

  void stopTimer() {
    timerController?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Widget AudioSlider = SliderTheme(
      data: SliderTheme.of(context).copyWith(
          // thumbShape: CustomSliderThumbRhombus(),
          ),
      child: Column(
        children: [
          Slider(
            activeColor: Colors.black,
            inactiveColor: Colors.black,
            value: _currentPlayTime.toDouble(),
            min: 0.0,
            max: _soundDuration.toDouble(),

            /*widget.audioDuration.inMilliseconds.toDouble()*/
            thumbColor: Colors.red,
            onChanged: (double value) {
              setState(() {
                _currentPlayTime = value.toInt();
              });
            },
            onChangeEnd: (_) {
              seek(_currentPlayTime);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Formatting.printDurationTime(
                  duration: Duration(
                    milliseconds: _currentPlayTime,
                  ),
                  formattingType: FormattingType.HourMinute,
                ),
              ),
              Text(
                Formatting.printDurationTime(
                  duration: Duration(
                    milliseconds: _soundDuration,
                  ),
                  formattingType: FormattingType.HourMinute,
                ),
              ),
            ],
          )
        ],
      ),
    );

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
              soundName,
              style: const TextStyle(
                fontFamily: 'TTNorms',
                fontWeight: FontWeight.w500,
                fontSize: 24,
                letterSpacing: 0.4,
              ),
            ),
            Expanded(
              child: AudioSlider,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      moveBackward();
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/15SecAgo.svg',
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: tooglePlay,
                    child: isPlayMode
                        ? const Icon(
                            Icons.pause_circle,
                            color: Color.fromRGBO(241, 180, 136, 1),
                            size: 80,
                          )
                        : const Icon(
                            Icons.play_circle,
                            color: Color.fromRGBO(241, 180, 136, 1),
                            size: 80,
                          ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  IconButton(
                    onPressed: () {
                      moveForward();
                    },
                    icon: SvgPicture.asset('assets/icons/15SecAfter.svg'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
