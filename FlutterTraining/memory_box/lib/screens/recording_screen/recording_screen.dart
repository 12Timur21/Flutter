import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_bloc.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_event.dart';
import 'package:memory_box/blocks/bottom_navigation_index_control/bottom_navigation_index_control_cubit.dart';
import 'package:memory_box/resources/app_coloros.dart';
import 'package:memory_box/screens/recording_screen/widgets/visualizer.dart';
import 'dart:async';
import 'dart:math';

import 'package:memory_box/services/soundRecorder.dart';
import 'package:memory_box/utils/formatting.dart';

class RecordingScreen extends StatefulWidget {
  static const routeName = 'RecordingScreen';

  const RecordingScreen({Key? key}) : super(key: key);

  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  bool isRecorderStreamInitialized = false;

  final SoundRecorder _recorder = SoundRecorder();
  StreamSubscription<RecordingDisposition>? _recorderSubscription;
  Timer? _timer;
  Duration? _audioDuration;

  @override
  void initState() {
    changeRecordingButton();
    _recorder
        .init()
        .then(
          (value) => {
            startRecording(),
            startTimer(),
            _recorderSubscription = _recorder.recorderStream?.listen((e) {}),
            setState(() {
              isRecorderStreamInitialized = true;
            }),
          },
        )
        .catchError((e) {
      Navigator.of(context).pop();
      //!Вывести 'Что-то пошло не так'
      log(e);
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    await _recorder.startRecording();
  }

  Future<void> finishRecording() async {
    await _recorder.finishRecording();
    BlocProvider.of<BottomSheetBloc>(context).add(
      OpenListeningPage(),
    );
  }

  void startTimer() {
    int seconds = 0;
    int minutes = 0;
    int hours = 0;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (seconds < 0) {
            timer.cancel();
          } else {
            seconds = seconds + 1;

            if (seconds > 59) {
              minutes += 1;
              seconds = 0;
              if (minutes > 59) {
                hours += 1;
                minutes = 0;
              }
            }
          }
          _audioDuration = Duration(
            hours: hours,
            minutes: minutes,
            seconds: seconds,
          );
        },
      ),
    );
  }

  void changeRecordingButton() {
    BlocProvider.of<BottomNavigationIndexControlCubit>(context).changeIcon(
      RecorderButtonStates.withLine,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      decoration: const BoxDecoration(
        color: AppColors.silverPhoenix,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0.3,
          ),
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 15),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: AppColors.silverPhoenix,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                right: 30,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Отменить',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'TTNorms',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: startRecording,
              child: const Text(
                'Запись',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'TTNorms',
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
          Expanded(
            child: Transform.rotate(
              angle: -pi,
              child: Visualizer(
                recorderSubscription: _recorderSubscription,
                isRecorderStreamInitialized: isRecorderStreamInitialized,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(
                  right: 5,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.appleBlossom,
                  shape: BoxShape.circle,
                ),
              ),
              //!Преобразовать
              Text(
                convertDurationToString(
                  duration: _audioDuration,
                  formattingType: TimeFormattingType.hourMinuteSecond,
                ),
                style: const TextStyle(
                  fontFamily: 'TTNorms',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GestureDetector(
                onTap: finishRecording,
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  child: const Icon(
                    Icons.pause_circle,
                    color: AppColors.tacao,
                    size: 80,
                  ),
                ),
              ),
              Container(
                color: AppColors.tacao,
                width: 5,
                height: 30,
              )
            ],
          ),
        ],
      ),
    );
  }
}
