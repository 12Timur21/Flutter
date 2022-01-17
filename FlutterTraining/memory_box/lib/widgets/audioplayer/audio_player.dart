import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/widgets/audioSlider.dart';

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({
    Key? key,
  }) : super(key: key);

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  bool _isPlay = false;

  void _tooglePlayMode() {
    print('object');
    setState(() {
      _isPlay = !_isPlay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioplayerBloc, AudioplayerState>(
      builder: (context, state) {
        print(state.currentPlayDuration);
        print(state.taleModel.duration);
        return SizedBox(
          height: 80,
          child: Container(
              decoration: const BoxDecoration(
                color: Colors.amber,
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(140, 132, 226, 1),
                    Color.fromRGBO(108, 104, 159, 1),
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
                    GestureDetector(
                      onTap: _tooglePlayMode,
                      child: SvgPicture.asset(
                        _isPlay
                            ? 'assets/icons/StopCircle.svg'
                            : 'assets/icons/CirclePlay.svg',
                        color: Colors.white,
                        width: 50,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.taleModel.title ?? ''),
                        AudioSlider(
                          onChanged: () {},
                          onChangeEnd: (_) {},
                        )
                      ],
                    ),
                    SvgPicture.asset('assets/icons/ArrowNext.svg'),
                  ],
                ),
              )),
        );
      },
    );
  }
}
