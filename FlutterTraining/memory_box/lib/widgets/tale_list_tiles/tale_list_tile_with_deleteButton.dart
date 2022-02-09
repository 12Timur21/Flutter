import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';

class TaleListTileWithDeleteButton extends StatefulWidget {
  const TaleListTileWithDeleteButton({
    required this.taleModel,
    Key? key,
  }) : super(key: key);

  final TaleModel taleModel;

  @override
  _TaleListTileWithDeleteButtonState createState() =>
      _TaleListTileWithDeleteButtonState();
}

class _TaleListTileWithDeleteButtonState
    extends State<TaleListTileWithDeleteButton> {
  bool _isPlay = false;
  bool _isDeleted = false;

  void _deleteTale() {
    String? taleID = widget.taleModel.ID;
    if (taleID != null) {
      DatabaseService.instance.finalDeleteTaleRecord(taleID);
      setState(() {
        _isDeleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_isDeleted,
      child: Container(
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
              color: const Color.fromRGBO(103, 139, 210, 1),
              width: 50,
            ),
          ),
          title: Text(widget.taleModel.title),
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
            onPressed: _deleteTale,
            icon: SvgPicture.asset(
              'assets/icons/Trash.svg',
            ),
          ),
        ),
      ),
    );
  }
}
