import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_bloc.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_event.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton._event.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_bloc.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_state.dart';
import 'package:memory_box/screens/recording_screen/widgets/visualizer.dart';
import 'dart:async';
import 'dart:math';

import 'package:memory_box/services/soundRecorder.dart';
import 'package:memory_box/utils/formatting.dart';

class RecordingPage extends StatefulWidget {
  static const routeName = 'RecordingPage';

  const RecordingPage({Key? key}) : super(key: key);

  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingPage> {
  bool isRecorderStreamInitialized = false;

  SoundRecorder recorder = SoundRecorder();
  StreamSubscription<RecordingDisposition>? recorderSubscription;
  Timer? _timer;
  Duration? _audioDuration;

  @override
  void initState() {
    changeRecordingButton();
    recorder
        .init()
        .then((value) async => {
              await startRecording(),
              startTimer(),
              recorderSubscription = recorder.recorderStream?.listen((e) {}),
              setState(() {
                isRecorderStreamInitialized = true;
              }),
            })
        .catchError((e) {
      Navigator.of(context).pop();
      log(e);
    });

    super.initState();
  }

  @override
  void dispose() {
    disposeTimer();
    disposeRecording();

    isRecorderStreamInitialized = false;
    super.dispose();
  }

  Future<void> startRecording() async {
    recorder.startRecording();
  }

  void stopRecoring() {
    recorder.finishRecording();
    navigateToListeningPage();
  }

  void disposeRecording() async {
    recorder.dispose();
    await recorderSubscription?.cancel();
    recorderSubscription = null;
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

  void disposeTimer() {
    _timer?.cancel();
  }

  void navigateToListeningPage() {
    dispose();
    BlocProvider.of<BottomSheetBloc>(context).add(
      OpenListeningPage(),
    );
  }

  void changeRecordingButton() {
    BlocProvider.of<RecorderButtomBloc>(context).add(
      const ChangeIcon(
        RecorderButtonStates.withLine,
      ),
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
        color: Color.fromRGBO(239, 239, 247, 1),
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
            color: Color.fromRGBO(239, 239, 247, 1),
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
              onTap: () {
                startRecording();
              },
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
                recorderSubscription: recorderSubscription,
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
                  color: Color.fromRGBO(226, 119, 119, 1),
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
                onTap: () {
                  stopRecoring();
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  child: const Icon(
                    Icons.pause_circle,
                    color: Color.fromRGBO(241, 180, 136, 1),
                    size: 80,
                  ),
                ),
              ),
              Container(
                color: const Color.fromRGBO(241, 180, 136, 1),
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
