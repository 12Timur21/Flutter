import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/repositories/storage_service.dart';

class AudioTaleTile extends StatefulWidget {
  AudioTaleTile({
    required this.taleID,
    required this.title,
    required this.taleDuration,
    required this.taleURL,
    Key? key,
  }) : super(key: key);

  final String taleID;
  final String title;
  final Duration taleDuration;
  final String taleURL;

  @override
  _AudioTaleTileState createState() => _AudioTaleTileState();
}

class _AudioTaleTileState extends State<AudioTaleTile> {
  late final TextEditingController _textFieldController;

  bool _isEditMode = false;
  bool _isPlay = false;

  @override
  void initState() {
    _textFieldController = TextEditingController(
      text: widget.title,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void addToPlayList() {}

    void deleteTale() {
      DatabaseService.instance.deleteTaleRecord(widget.taleID);
    }

    void shareTale() {}

    void save() {
      DatabaseService.instance.updateTaleData(
        taleID: widget.taleID,
        title: _textFieldController.value.text,
      );
    }

    void _changeEditMode() {
      setState(() {
        _isEditMode = !_isEditMode;
        if (!_isEditMode) {
          save();
        }
      });
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(41),
        border: Border.all(
          color: const Color.fromRGBO(58, 58, 85, 0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        leading: SvgPicture.asset(
          _isPlay
              ? 'assets/icons/StopCircle.svg'
              : 'assets/icons/CirclePlay.svg',
          color: const Color.fromRGBO(94, 119, 206, 1),
          width: 50,
        ),
        title: TextFormField(
          enabled: _isEditMode,
          controller: _textFieldController,
          validator: (value) {
            if (value?.isEmpty == true || value == null) {
              return 'Название не может быть пустым';
            }
            return null;
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            isDense: true,
            border: _isEditMode
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  )
                : InputBorder.none,
            focusedBorder: const UnderlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
          ),
        ),
        horizontalTitleGap: 20,
        subtitle: _isEditMode
            ? null
            : Text(
                widget.taleDuration.inMinutes != 0
                    ? '${widget.taleDuration.inMinutes} минут'
                    : '${widget.taleDuration.inSeconds} секунд',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'TTNorms',
                  fontWeight: FontWeight.normal,
                  color: Color.fromRGBO(58, 58, 85, 0.5),
                  letterSpacing: 0.1,
                ),
              ),
        trailing: PopupMenuButton(
          elevation: 10,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          icon: SvgPicture.asset(
            'assets/icons/More.svg',
            color: Colors.black,
            width: 25,
          ),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: _isEditMode
                    ? const Text('Сохранить')
                    : const Text('Переименовать'),
                onTap: _changeEditMode,
              ),
              PopupMenuItem(
                child: const Text('Добавить в подборку'),
                onTap: addToPlayList,
              ),
              PopupMenuItem(
                child: const Text('Удалить'),
                onTap: deleteTale,
              ),
              PopupMenuItem(
                child: const Text('Поделиться'),
                onTap: shareTale,
              )
            ];
          },
        ),
      ),
    );
  }
}
