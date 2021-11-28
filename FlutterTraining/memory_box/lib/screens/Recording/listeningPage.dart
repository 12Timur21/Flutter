import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_bloc.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton._event.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_bloc.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_state.dart';
import 'package:memory_box/services/soundPlayer.dart';
import 'package:memory_box/utils/formatting.dart';
import 'package:memory_box/widgets/bottomSheetWrapper.dart';

class ListeningPage extends StatefulWidget {
  static const routeName = 'ListeningPage';

  const ListeningPage({required this.audioDuration, Key? key})
      : super(key: key);
  final Duration audioDuration;
  @override
  _ListeningPageState createState() => _ListeningPageState();
}

class _ListeningPageState extends State<ListeningPage> {
  final String soundName = 'Аудиозапись 1';
  bool isPlayMode = false;
  Duration audioDuration = Duration(hours: 0, minutes: 0, seconds: 0);

  SoundPlayer _soundPlayer = SoundPlayer();

  @override
  void initState() {
    changeRecordingButton();
    initAudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _soundPlayer.dispose();
    super.dispose();
  }

  void initAudioPlayer() async {
    await _soundPlayer.init();
    print('second step');
    audioDuration = Duration(
      milliseconds: await _soundPlayer.audioDurationInMs ?? 0,
    );
    setState(() {});
  }

  void shareSound() {
    _soundPlayer.shareSound();
  }

  void localDownloadSound() {
    _soundPlayer.localDownloadSound();
  }

  void deleteSound() async {
    _soundPlayer.deleteSound();
    Navigator.of(context).pop();
  }

  void saveSound() {
    Navigator.of(context).pop();
  }

  void tooglePlay() {
    setState(() {
      isPlayMode = !isPlayMode;
      if (isPlayMode) {
        _soundPlayer.playLocal();
      } else {
        _soundPlayer.pauseLocal();
      }
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

  double currentPlayTime = 0;
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
            value: currentPlayTime,
            min: 0.0,
            max: audioDuration.inMilliseconds.toDouble(),

            /*widget.audioDuration.inMilliseconds.toDouble()*/
            thumbColor: Colors.red,
            onChanged: (double value) {
              setState(() {
                currentPlayTime = value;
              });
            },
            onChangeEnd: (double value) {
              currentPlayTime = value;
              _soundPlayer.audioPlayer?.seek(
                Duration(
                  milliseconds: currentPlayTime.toInt(),
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('00:00'),
              Text(
                Formatting.printDurationTime(audioDuration),
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
                    onPressed: () {},
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
                    onPressed: () {},
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
