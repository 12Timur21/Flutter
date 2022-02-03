import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/models/tale_model.dart';

class TaleListTileWithCheckBox extends StatefulWidget {
  const TaleListTileWithCheckBox({
    required this.taleModel,
    this.isPlayMode = false,
    this.isSelected = false,
    Key? key,
    required this.subscribeTale,
    required this.unSubscribeTale,
    required this.onPlay,
    required this.onPause,
  }) : super(key: key);

  final TaleModel taleModel;
  final bool isSelected;
  final bool isPlayMode;

  final VoidCallback subscribeTale;
  final VoidCallback unSubscribeTale;

  final VoidCallback onPlay;
  final VoidCallback onPause;

  @override
  _TaleListTileWithCheckBoxState createState() =>
      _TaleListTileWithCheckBoxState();
}

class _TaleListTileWithCheckBoxState extends State<TaleListTileWithCheckBox> {
  void _selectTale() {
    if (widget.isSelected) {
      widget.unSubscribeTale();
    } else {
      widget.subscribeTale();
    }
  }

  void _tooglePlayMode() {
    if (widget.isPlayMode) {
      widget.onPause();
    } else {
      widget.onPlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(41),
        color: const Color.fromRGBO(246, 246, 246, 1),
        border: Border.all(
          color: const Color.fromRGBO(58, 58, 85, 0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        leading: GestureDetector(
          onTap: _tooglePlayMode,
          child: SvgPicture.asset(
            widget.isPlayMode
                ? 'assets/icons/StopCircle.svg'
                : 'assets/icons/PlayCircle.svg',
            color: const Color.fromRGBO(113, 165, 159, 1),
            width: 50,
          ),
        ),
        title: Text(widget.taleModel.title ?? ''),
        horizontalTitleGap: 20,
        subtitle: Text(
          widget.taleModel.duration?.inMinutes != 0
              ? '${widget.taleModel.duration?.inMinutes ?? 0} минут'
              : '${widget.taleModel.duration?.inSeconds ?? 0} секунд',
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'TTNorms',
            fontWeight: FontWeight.normal,
            color: Color.fromRGBO(58, 58, 85, 0.5),
            letterSpacing: 0.1,
          ),
        ),
        trailing: IconButton(
          onPressed: _selectTale,
          icon: widget.isSelected
              ? SvgPicture.asset(
                  'assets/icons/SubmitCircle.svg',
                )
              : SvgPicture.asset(
                  'assets/icons/Circle.svg',
                ),
        ),
      ),
    );
  }
}
