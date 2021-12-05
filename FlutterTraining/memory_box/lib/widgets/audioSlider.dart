import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/services/soundPlayer.dart';
import 'package:memory_box/utils/formatting.dart';

class AudioSlider extends StatefulWidget {
  const AudioSlider({
    // required
    Key? key,
  }) : super(key: key);

  @override
  _AudioSliderState createState() => _AudioSliderState();
}

class _AudioSliderState extends State<AudioSlider> {
  // SoundPlayer? _soundPlayer;
  // Duration? _currentPlayTime;
  // Duration? _soundDuration;

  @override
  void initState() {
    // _soundPlayer = SoundPlayer();
    // _soundPlayer?.soundDurationStream?.listen((e) {
    //   setState(() {
    //     _currentPlayTime = e.position;
    //     _soundDuration = e.duration;
    //   });
    // });
    super.initState();
  }

  void seek(double ms) {
    // _soundPlayer?.seek(
    //   playTimeInMS: _currentPlayTime!.inMilliseconds.toInt(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final _audioBloc = BlocProvider.of<AudioplayerBloc>(context);
    print(_audioBloc.state.isPlay);
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        overlayShape: SliderComponentShape.noOverlay,
        // thumbShape: CustomSliderThumbRhombus(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Slider(
            activeColor: Colors.black,
            inactiveColor: Colors.black,
            value: 1,
            min: 0.0,
            max: 100,
            thumbColor: Colors.red,
            onChanged: (double value) {
              seek(value);
            },
            onChangeEnd: (double value) {
              seek(value);
            },
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text(
              //   Formatting.printDurationTime(
              //     duration: _currentPlayTime,
              //     formattingType: FormattingType.HourMinute,
              //   ),
              // ),
              // Text(
              //   Formatting.printDurationTime(
              //     duration: _soundDuration,
              //     formattingType: FormattingType.HourMinute,
              //   ),
              // ),
            ],
          )
        ],
      ),
    );
  }
}
