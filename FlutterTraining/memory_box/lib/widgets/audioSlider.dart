import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/services/soundPlayer.dart';
import 'package:memory_box/utils/formatting.dart';

class AudioSlider extends StatefulWidget {
  const AudioSlider({
    required this.onChanged,
    required this.onChangeEnd,
    this.currentPlayDuration,
    this.soundDuration,
    Key? key,
  }) : super(key: key);

  final Function onChanged;
  final Function(double) onChangeEnd;
  final Duration? currentPlayDuration;
  final Duration? soundDuration;

  @override
  _AudioSliderState createState() => _AudioSliderState();
}

class _AudioSliderState extends State<AudioSlider> {
  double sliderTimeValue = 0;

  @override
  void initState() {
    sliderTimeValue =
        widget.currentPlayDuration?.inMilliseconds.toDouble() ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            max: widget.soundDuration?.inSeconds.toDouble() ?? 0,
            min: 0.0,
            value: sliderTimeValue,
            thumbColor: Colors.red,
            onChanged: (double value) {
              widget.onChanged();
              setState(() {
                sliderTimeValue = value;
              });
            },
            onChangeEnd: (double value) {
              setState(() {
                sliderTimeValue = value;
              });
              widget.onChangeEnd(value);
            },
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                printDurationTime(
                  duration: widget.currentPlayDuration,
                  formattingType: FormattingType.HourMinute,
                ),
              ),
              Text(
                printDurationTime(
                  duration: widget.soundDuration,
                  formattingType: FormattingType.HourMinute,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
