import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/blocks/list_builder/list_builder_bloc.dart';
import 'package:memory_box/models/playlist_model.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/repositories/storage_service.dart';
import 'package:memory_box/resources/app_coloros.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/utils/formatting.dart';
import 'package:memory_box/widgets/audioplayer/audio_player.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/tale_list_tiles/tale_list_tile_with_popup_menu.dart';
import 'package:memory_box/widgets/undoButton.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';

class DetailedPlaylistScreen extends StatefulWidget {
  static const routeName = 'DetailedPlaylistScreen';

  const DetailedPlaylistScreen({
    required this.playlistModel,
    Key? key,
  }) : super(key: key);

  final PlaylistModel playlistModel;

  @override
  _DetailedPlaylistScreenState createState() => _DetailedPlaylistScreenState();
}

enum ScreenMode {
  defaultMode,
  editMode,
  selectMode,
}

class _DetailedPlaylistScreenState extends State<DetailedPlaylistScreen> {
  final _formController = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isImageValid = true;
  bool _isEditEnd = true;
  File? _playlistCoverFile;

  ScreenMode _screenMode = ScreenMode.defaultMode;

  @override
  void initState() {
    _titleController.value = TextEditingValue(text: widget.playlistModel.title);
    if (widget.playlistModel.description != null) {
      _descriptionController.value =
          TextEditingValue(text: widget.playlistModel.description!);
    }

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  void _pop() {
    Navigator.of(context).pop(
      widget.playlistModel,
    );
  }

  Future<void> _pickImage() async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    String? path = pickedImage?.path;
    if (path != null) {
      setState(() {
        _playlistCoverFile = File(path);
      });
    }
  }

  bool _validateImageField() {
    setState(() {
      if (_playlistCoverFile != null) {
        _isImageValid = true;
      } else {
        _isImageValid = false;
      }
    });

    return _isImageValid;
  }

  void _undoEditChanges() {
    setState(() {
      if (_formController.currentState!.validate() && _isImageValid) {
        _titleController.value =
            TextEditingValue(text: widget.playlistModel.title);

        if (widget.playlistModel.description != null) {
          _descriptionController.value =
              TextEditingValue(text: widget.playlistModel.description!);
        }
      }
      _screenMode = ScreenMode.defaultMode;
    });
  }

  void _saveEditChanges() async {
    // if (_formController.currentState?.validate() ?? false) {
    //   setState(() {
    //     widget.playlistModel = widget.playlistModel.copyWith(
    //       title: _titleController.text,
    //       description: _descriptionController.text,
    //     );
    //     _screenMode = ScreenMode.defaultMode;
    //   });
    // }

    // if (_playlistCoverFile != null) {
    //   setState(() {
    //     _isEditEnd = false;
    //   });
    //   String updatedUrl = await StorageService.instance.uploadPlayListCover(
    //     coverID: widget.playlistModel.ID,
    //     file: _playlistCoverFile!,
    //   );

    //   setState(() {
    //     _isEditEnd = true;
    //     widget.playlistModel = widget.playlistModel.copyWith(
    //       coverUrl: updatedUrl,
    //     );
    //     _screenMode = ScreenMode.defaultMode;
    //   });
    // }
  }

  Future<void> _addTales() async {
    // List<TaleModel>? _listTaleModels = await Navigator.of(context).pushNamed(
    //   SelectTalesToPlaylistScreen.routeName,
    //   arguments: _listBuilderBloc.state.allTales,
    // ) as List<TaleModel>?;

    // _listBuilderBloc.add(
    //   InitializeListBuilderWithTaleModels(_listTaleModels),
    // );

    // if (_listTaleModels != null) {
    //   await DatabaseService.instance.addTalesToFewPlaylist(
    //     taleModels: _listTaleModels,
    //     playlistModels: [widget.playlistModel],
    //   );
    // }

    // setState(() {
    //   widget.playlistModel = widget.playlistModel.copyWith(
    //     taleModels: _listTaleModels,
    //   );
    // });
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _popupMenuTextStyle = const TextStyle(
      fontFamily: 'TTNorms',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Colors.black,
    );

    TextStyle _playlistCoverTextStyle = const TextStyle(
      fontFamily: 'TTNorms',
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.white,
    );

    Widget _playlistCoverWidget = GestureDetector(
      onTap: _screenMode == ScreenMode.editMode ? _pickImage : null,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.wildSand.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 20,
              // spreadRadius: 1,
              color: Colors.black.withOpacity(0.25),
            ),
          ],
        ),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: _playlistCoverFile == null
                    ? Image.network(
                        widget.playlistModel.coverUrl,
                        fit: BoxFit.fitWidth,
                      )
                    : Image.file(
                        _playlistCoverFile!,
                        fit: BoxFit.fitWidth,
                      ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black.withOpacity(0),
                    AppColors.gray,
                  ],
                ),
              ),
            ),
            if (_screenMode == ScreenMode.editMode)
              Center(
                child: SvgPicture.asset(
                  AppIcons.chosePhoto,
                  color: Colors.black,
                ),
              ),
            if (_screenMode != ScreenMode.selectMode)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          convertDateTimeToString(
                            date: widget.playlistModel.creation_date,
                            dayTimeFormattingType:
                                DayTimeFormattingType.dayMonthYear,
                          ),
                          style: _playlistCoverTextStyle,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.playlistModel.taleModels.length} аудио',
                              style: _playlistCoverTextStyle,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${convertDurationToString(
                                duration: widget.playlistModel.taleModels
                                    .fold<Duration>(
                                  Duration.zero,
                                  (Duration previousValue, element) =>
                                      previousValue + element.duration,
                                ),
                                formattingType: TimeFormattingType.hourMinute,
                              )} часов',
                              style: _playlistCoverTextStyle,
                            ),
                          ],
                        )
                      ],
                    ),
                    if (_screenMode != ScreenMode.selectMode)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            // _listBuilderBloc.add(
                            //   TooglePlayAllMode(),
                            // );
                            // setState(() {});
                          },
                          child: Container(
                            width: 168,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.wildSand.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            // child: Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     Padding(
                            //       padding: const EdgeInsets.all(3),
                            //       child: SvgPicture.asset(
                            //         _listBuilderBloc.state.isPlayAllTalesMode
                            //             ? AppIcons.stopCircle
                            //             : AppIcons.playCircle,
                            //         width: 45,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //     const SizedBox(
                            //       width: 10,
                            //     ),
                            //     _listBuilderBloc.state.isPlayAllTalesMode
                            //         ? const Text(
                            //             'Остановить',
                            //             style: TextStyle(
                            //               fontFamily: 'TTNorms',
                            //               fontSize: 14,
                            //               fontWeight: FontWeight.normal,
                            //               color: Colors.white,
                            //             ),
                            //           )
                            //         : const Text(
                            //             'Запустить все',
                            //             style: TextStyle(
                            //               fontFamily: 'TTNorms',
                            //               fontSize: 14,
                            //               fontWeight: FontWeight.normal,
                            //               color: Colors.white,
                            //             ),
                            //           ),
                            //   ],
                            // ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    Widget _selectPopupMenuButton = PopupMenuButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      onSelected: (_) {
        Navigator.of(context).pop();
      },
      child: Center(
        child: SvgPicture.asset(
          AppIcons.more,
          color: Colors.white,
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              setState(() {
                _screenMode = ScreenMode.defaultMode;
              });
            },
            child: Text(
              "Отменить выбор",
              style: _popupMenuTextStyle,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              setState(() {
                _screenMode = ScreenMode.selectMode;
              });
            },
            child: Text(
              "Добавить в подборку",
              style: _popupMenuTextStyle,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              // String taleUrls = '';
              // _selectListBuilderBloc.state.selectedTales.forEach((element) {
              //   taleUrls += '\n ${element.url}';
              // });
              // Share.share(taleUrls);
            },
            child: Text(
              "Поделиться ",
              style: _popupMenuTextStyle,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {},
            child: Text(
              "Скачать все",
              style: _popupMenuTextStyle,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              // _selectListBuilderBloc.state.selectedTales.forEach((element) {
              //   DatabaseService.instance.updateTale(taleID: element.ID);
              // });
            },
            child: Text(
              "Удалить все",
              style: _popupMenuTextStyle,
            ),
          ),
        ),
      ],
    );

    Widget _popupMenuButton = PopupMenuButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      onSelected: (_) {
        Navigator.of(context).pop();
      },
      child: Center(
        child: SvgPicture.asset(
          AppIcons.more,
          color: Colors.white,
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              print('asdasdas');
              print(_screenMode);
              setState(() {
                _screenMode = ScreenMode.editMode;
              });
            },
            child: Text(
              "Редактировать",
              style: _popupMenuTextStyle,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              setState(() {
                _screenMode = ScreenMode.selectMode;
              });
            },
            child: Text(
              "Выделить несколько",
              style: _popupMenuTextStyle,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {},
            child: Text(
              "Скачать",
              style: _popupMenuTextStyle,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {},
            child: Text(
              "Удалить",
              style: _popupMenuTextStyle,
            ),
          ),
        ),
      ],
    );

    return BackgroundPattern(
      patternColor: AppColors.seaNymph,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          primary: true,
          toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: UndoButton(
            undoChanges:
                _screenMode == ScreenMode.editMode ? _undoEditChanges : _pop,
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(
                top: 20,
                right: 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_screenMode == ScreenMode.editMode) ...[
                    TextButton(
                      onPressed: _saveEditChanges,
                      child: const Text(
                        'Сохранить изменения',
                        style: TextStyle(
                          fontFamily: 'TTNorms',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ] else if (_screenMode == ScreenMode.selectMode) ...[
                    _selectPopupMenuButton
                  ] else ...[
                    _popupMenuButton,
                  ],
                ],
              ),
            )
          ],
          elevation: 0,
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider<ListBuilderBloc>(
              create: (_) => ListBuilderBloc()
                ..add(
                  InitializeListBuilderWithTaleModels(
                    widget.playlistModel.taleModels,
                  ),
                ),
            ),
            BlocProvider<AudioplayerBloc>(
              create: (_) => AudioplayerBloc()
                ..add(
                  InitPlayer(),
                ),
            ),
          ],
          child: Builder(
            builder: (context) {
              final listBuilderBloc = context.read<ListBuilderBloc>();
              final audioPlayerBloc = context.read<AudioplayerBloc>();

              return !_isEditEnd
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      margin: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Form(
                          key: _formController,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                enabled: _screenMode == ScreenMode.editMode,
                                controller: _titleController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Пожалуйста, введите название подборки';
                                  }

                                  if (text.length > 20) {
                                    return 'Слишком длинное название';
                                  }

                                  return null;
                                },
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Название...',
                                  border: _screenMode == ScreenMode.editMode
                                      ? null
                                      : InputBorder.none,
                                  hintStyle: const TextStyle(
                                    fontFamily: 'TTNorms',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    letterSpacing: 0.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              _playlistCoverWidget,
                              const SizedBox(
                                height: 30,
                              ),
                              if (widget.playlistModel.description != null &&
                                  _screenMode != ScreenMode.editMode) ...[
                                ReadMoreText(
                                  widget.playlistModel.description!,
                                  trimLines: 5,
                                  colorClickableText: Colors.pink,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Подробнее',
                                  trimExpandedText: 'Свернуть',
                                  style: const TextStyle(
                                    fontFamily: 'TTNorms',
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                  moreStyle: const TextStyle(
                                    fontFamily: 'TTNorms',
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.darkPurple,
                                  ),
                                  lessStyle: const TextStyle(
                                    fontFamily: 'TTNorms',
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.darkPurple,
                                  ),
                                ),
                              ] else ...[
                                TextFormField(
                                  style: const TextStyle(
                                    fontFamily: 'TTNorms',
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _descriptionController,
                                  decoration: const InputDecoration(
                                    hintText: 'Введите описание...',
                                    focusColor: Colors.red,
                                  ),
                                  validator: (text) {
                                    if (text != null && text.length > 400) {
                                      return 'Слишком длинное название';
                                    }

                                    return null;
                                  },
                                  maxLines: null,
                                  minLines: 1,
                                ),
                              ],
                              const SizedBox(
                                height: 30,
                              ),
                              SizedBox(
                                height: 300,
                                child: listBuilderBloc.state.allTales.isNotEmpty
                                    ? const _ListBuilder()
                                    : Center(
                                        child: TextButton(
                                          onPressed: () {},
                                          // widget.onAddTalesButtonPressed,
                                          child: const Text(
                                            'Тут пока нет записей',
                                            style: TextStyle(
                                              fontFamily: 'TTNorms',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Colors.transparent,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: Colors.black,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black,
                                                  offset: Offset(0, -5),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class _ListBuilder extends StatefulWidget {
  const _ListBuilder({Key? key}) : super(key: key);

  @override
  State<_ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<_ListBuilder> {
  @override
  Widget build(BuildContext context) {
    final listBuilderBloc = context.read<ListBuilderBloc>();
    final audioPlayerBloc = context.read<AudioplayerBloc>();

    return BlocConsumer<ListBuilderBloc, ListBuilderState>(
      listener: (context, state) {
        if (state is PlayTaleState) {
          final TaleModel taleModel = state.currentPlayTaleModel!;
          audioPlayerBloc.add(
            Play(
              taleModel: taleModel,
              isAutoPlay: true,
            ),
          );
        }

        if (state is StopTaleState) {
          audioPlayerBloc.add(
            Pause(),
          );
        }
      },
      builder: (context, listBuilderState) {
        return Stack(
          children: [
            ListView.builder(
              itemCount: listBuilderState.allTales.length + 1,
              itemBuilder: (context, index) {
                if (listBuilderState.allTales.length == index) {
                  return const SizedBox(
                    height: 90,
                  );
                }

                TaleModel taleModel = listBuilderState.allTales[index];
                bool isPlayMode = false;

                if (listBuilderState.currentPlayTaleModel == taleModel &&
                    listBuilderState.isPlay) {
                  isPlayMode = true;
                }

                return TaleListTileWithPopupMenu(
                    key: UniqueKey(),
                    isPlayMode: isPlayMode,
                    taleModel: taleModel,
                    onAddToPlaylist: () {},
                    onDelete: () {
                      listBuilderBloc.add(
                        DeleteTale(taleModel),
                      );
                    },
                    onRename: (String newTitle) {
                      listBuilderBloc.add(
                        RenameTale(
                          taleModel.ID,
                          newTitle,
                        ),
                      );
                    },
                    onShare: () {
                      Share.share(taleModel.url);
                    },
                    onUndoRenaming: () {
                      listBuilderBloc.add(
                        UndoRenameTale(),
                      );
                    },
                    tooglePlayMode: () {
                      // widget.onFocus;
                      listBuilderBloc.add(
                        TooglePlayMode(
                          taleModel: taleModel,
                        ),
                      );
                    });
              },
            ),
            const _AudioPlayer(),
          ],
        );
      },
    );
  }
}

class _AudioPlayer extends StatelessWidget {
  const _AudioPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listBuilderBloc = context.read<ListBuilderBloc>();
    final audioPlayerBloc = context.read<AudioplayerBloc>();

    return BlocConsumer<AudioplayerBloc, AudioplayerState>(
      listener: (context, state) {
        if (state.isTaleEnd) {
          if (listBuilderBloc.state.isPlayAllTalesMode) {
            listBuilderBloc.add(
              NextTale(),
            );
          } else {
            listBuilderBloc.add(
              TooglePlayMode(),
            );
            audioPlayerBloc.add(
              AnnulAudioPlayer(),
            );
          }
        }
      },
      builder: (context, state) {
        if (state.isTaleInit) {
          return Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            child: AudioPlayer(
              taleModel: state.taleModel,
              currentPlayPosition: state.currentPlayPosition,
              isPlay: listBuilderBloc.state.isPlay,
              tooglePlayMode: () {
                listBuilderBloc.add(
                  TooglePlayMode(
                    taleModel: state.taleModel,
                  ),
                );
              },
              onSliderChangeEnd: (value) {
                audioPlayerBloc.add(
                  Seek(currentPlayTimeInSec: value),
                );
              },
              onSliderChanged: () => {},
              next: () {
                listBuilderBloc.add(
                  NextTale(),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
