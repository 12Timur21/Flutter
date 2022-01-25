import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/resources/app_coloros.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/widgets/audioSlider.dart';

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({
    required this.taleModel,
    this.isPlay = false,
    required this.currentPlayDuration,
    required this.next,
    required this.pause,
    required this.play,
    required this.seek,
    Key? key,
  }) : super(key: key);

  final TaleModel taleModel;
  final bool isPlay;
  final Duration? currentPlayDuration;

  final Function pause;
  final Function play;
  final Function(double) seek;
  final Function next;

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  void _onSlidedChangeEnd(double value) {
    widget.seek(value);
  }

  void _tooglePlayMode() {
    print(widget.isPlay);
    if (widget.isPlay) {
      widget.play();
    } else {
      widget.pause();
    }
  }

  void _nextTale() {
    widget.next();
  }
  // if (isPlay == true) {
  //   _audioplayerBloc.add(
  //     Pause(),
  //   );
  // } else {
  //   _audioplayerBloc.add(
  //     Play(
  //       taleModel: _audioplayerBloc.state.taleModel,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.amber,
        gradient: LinearGradient(
          colors: [
            AppColors.blueMagenta,
            AppColors.kimberly,
          ],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(71),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _tooglePlayMode,
              padding: const EdgeInsets.all(0),
              alignment: Alignment.center,
              icon: SvgPicture.asset(
                widget.isPlay ? AppIcons.stopCircle : AppIcons.playCircle,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.taleModel.title ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'TTNorms',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    AudioSlider(
                      onChanged: () {},
                      onChangeEnd: _onSlidedChangeEnd,
                      currentPlayDuration: widget.currentPlayDuration,
                      taleDuration: widget.taleModel.duration,
                      primaryColor: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10,
              ),
              child: GestureDetector(
                onTap: _nextTale,
                child: SvgPicture.asset(
                  AppIcons.arrowNext,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
