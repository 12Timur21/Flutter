import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/bloc/list_builder_bloc.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/screens/playlist_screen/playlist_screen.dart';
import 'package:memory_box/utils/navigationService.dart';

class TaleListTileWithPopupMenu extends StatefulWidget {
  const TaleListTileWithPopupMenu({
    required this.taleModel,
    Key? key,
  }) : super(key: key);

  final TaleModel taleModel;

  @override
  _TaleListTileWithPopupMenuState createState() =>
      _TaleListTileWithPopupMenuState();
}

class _TaleListTileWithPopupMenuState extends State<TaleListTileWithPopupMenu> {
  late final TaleModel _taleModel;
  late final TextEditingController _textFieldController;

  bool _isEditMode = false;
  bool _isPlay = false;

  late FocusNode _myFocusNode;

  @override
  void initState() {
    super.initState();
    _myFocusNode = FocusNode();
    _taleModel = widget.taleModel;
    _textFieldController = TextEditingController(
      text: _taleModel.title,
    );
  }

  void _addToPlayList() {
    // NavigationService.instance.navigateTo(
    //   PlaylistScreen.routeName,
    //   arguments: _taleModel.ID,
    // );
  }

  void _deleteTale() {
    String? taleID = _taleModel.ID;
    if (taleID != null) {
      BlocProvider.of<ListBuilderBloc>(context).add(DeleteTale(taleID));
    }
  }

  void _shareTale() {
    String? taleUrl = _taleModel.url;
    if (taleUrl != null) {
      BlocProvider.of<ListBuilderBloc>(context).add(
        ShareTale(taleUrl),
      );
    }
  }

  void _undoChanges() {
    BlocProvider.of<ListBuilderBloc>(context).add(
      UndoRenameTale(),
    );
  }

  void _save() async {
    String? taleID = _taleModel.ID;
    if (taleID != null) {
      BlocProvider.of<ListBuilderBloc>(context).add(
        RenameTale(
          taleID,
          _textFieldController.value.text,
        ),
      );
    }

    setState(() {
      _isEditMode = false;
    });
  }

  void _openEditMode() {
    setState(() {
      _isEditMode = true;
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _myFocusNode.requestFocus();
    });
  }

  void _onFocusChange(hasFocus) {
    print(hasFocus);
    if (!hasFocus) {
      _undoChanges();
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
          onTap: () {
            setState(() {
              _isPlay = !_isPlay;
            });
            // _myFocusNode.requestFocus();
            // myFocusNode.unfocus();
            // showModalBottomSheet(
            //   context: context,
            //   useRootNavigator: true,
            //   enableDrag: false,
            //   barrierColor: Colors.transparent,
            //   builder: (BuildContext context) {
            //     return const BottomSheetChangeConfirmation();
            //   },
            // );
          },
          child: SvgPicture.asset(
            _isPlay
                ? 'assets/icons/StopCircle.svg'
                : 'assets/icons/CirclePlay.svg',
            color: const Color.fromRGBO(94, 119, 206, 1),
            width: 50,
          ),
        ),
        title: Focus(
          onFocusChange: _onFocusChange,
          child: TextFormField(
            enabled: _isEditMode,
            controller: _textFieldController,
            focusNode: _myFocusNode,
            textInputAction: TextInputAction.done,
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
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
        horizontalTitleGap: 20,
        subtitle: _isEditMode
            ? null
            : Text(
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
        trailing: _isEditMode
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _save,
                    icon: const Icon(
                      Icons.task_alt,
                    ),
                  ),
                  IconButton(
                    onPressed: _undoChanges,
                    icon: const Icon(
                      Icons.cancel,
                    ),
                  )
                ],
              )
            : PopupMenuButton(
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
                onSelected: (result) {
                  switch (result) {
                    case 0:
                      _openEditMode();
                      break;
                    case 1:
                      _addToPlayList();
                      break;
                    case 2:
                      _deleteTale();
                      break;
                    case 3:
                      _shareTale();
                      break;
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 0,
                      child: _isEditMode
                          ? const Text('Сохранить')
                          : const Text('Переименовать'),

                      // onTap: _openEditMode,
                    ),
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Добавить в подборку'),
                      // onTap: _addToPlayList,
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text('Удалить'),
                      // onTap: ,
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: Text('Поделиться'),
                      // onTap: ,
                    )
                  ];
                },
              ),
      ),
    );
  }
}
