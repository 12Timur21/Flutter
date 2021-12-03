import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/services/soundPlayer.dart';

class SoundControlButtons extends StatefulWidget {
  const SoundControlButtons({
    Key? key,
    required this.tooglePlay,
    required this.moveBackward,
    required this.moveForward,
  }) : super(key: key);

  final Function tooglePlay;
  final Function moveForward;
  final Function moveBackward;

  @override
  _SoundControlButtonsState createState() => _SoundControlButtonsState();
}

class _SoundControlButtonsState extends State<SoundControlButtons> {
  bool isPlayMode = false;

  @override
  void initState() {
    super.initState();
  }

  void tooglePlay() {
    setState(() {
      isPlayMode = !isPlayMode;
    });
    widget.tooglePlay();
  }

  void moveForward() {
    widget.moveForward();
  }

  void moveBackward() {
    widget.moveBackward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              moveBackward();
              // _soundPlayer?.moveBackward();
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
              moveBackward();
              // _soundPlayer?.moveForward();
            },
            icon: SvgPicture.asset('assets/icons/15SecAfter.svg'),
          ),
        ],
      ),
    );
  }
}
