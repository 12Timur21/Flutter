import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/repositories/storage_service.dart';
import 'package:memory_box/widgets/bottom_sheet_change_confirmation.dart';

class TaleListTileWithCheckBox extends StatefulWidget {
  TaleListTileWithCheckBox({
    required this.taleModel,
    Key? key,
    required this.subscribeTale,
    required this.unSubscribeTale,
    this.isSelected = false,
  }) : super(key: key);

  final TaleModel taleModel;
  bool isSelected;

  final Function(String) subscribeTale;
  final Function(String) unSubscribeTale;

  @override
  _TaleListTileWithCheckBoxState createState() =>
      _TaleListTileWithCheckBoxState();
}

class _TaleListTileWithCheckBoxState extends State<TaleListTileWithCheckBox> {
  late final TaleModel _taleModel;
  bool _isPlay = false;

  @override
  void initState() {
    super.initState();
    _taleModel = widget.taleModel;
  }

  void _selectTale() {
    setState(() {
      widget.isSelected = !widget.isSelected;
      if (widget.isSelected) {
        widget.subscribeTale(_taleModel.ID ?? '');
      } else {
        widget.unSubscribeTale(_taleModel.ID ?? '');
      }
    });
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
          onTap: () {},
          child: SvgPicture.asset(
            _isPlay
                ? 'assets/icons/StopCircle.svg'
                : 'assets/icons/CirclePlay.svg',
            color: const Color.fromRGBO(113, 165, 159, 1),
            width: 50,
          ),
        ),
        title: Text(_taleModel.title ?? ''),
        horizontalTitleGap: 20,
        subtitle: Text(
          _taleModel.duration?.inMinutes != 0
              ? '${_taleModel.duration?.inMinutes ?? 0} минут'
              : '${_taleModel.duration?.inSeconds ?? 0} секунд',
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
