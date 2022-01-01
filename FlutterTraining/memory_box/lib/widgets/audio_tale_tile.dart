import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/models/tale_model.dart';

class AudioTaleTile extends StatefulWidget {
  AudioTaleTile({
    // this.subscribeSound,
    // this.isSelected = false,
    this.taleModel,
    required this.actions,
    Key? key,
  }) : super(key: key);
  // final StreamController<String?>? subscribeSound;
  final TaleModel? taleModel;
  // final bool isSelected;
  Widget actions;
  @override
  _AudioTaleTileState createState() => _AudioTaleTileState();
}

class _AudioTaleTileState extends State<AudioTaleTile> {
  bool isSelected = false;

  @override
  void initState() {
    // isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void selectSound() {
      setState(() {
        // widget.subscribeSound?.add(widget.taleModel?.ID);
        isSelected = !isSelected;
      });
    }

    return Container(
      margin: const EdgeInsets.only(
        top: 10,
      ),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(41)),
        border: Border.all(
          color: const Color.fromRGBO(58, 58, 85, 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/Play.svg',
            color: const Color.fromRGBO(113, 165, 159, 1),
            width: 60,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.taleModel?.title ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'TTNorms',
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.taleModel?.duration?.inMinutes != 0
                      ? '${widget.taleModel?.duration?.inMinutes} минут'
                      : '${widget.taleModel?.duration?.inSeconds} секунд',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'TTNorms',
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(58, 58, 85, 0.5),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 60,
            height: 60,
            child: widget.actions,
          ),
        ],
      ),
    );
  }
}
