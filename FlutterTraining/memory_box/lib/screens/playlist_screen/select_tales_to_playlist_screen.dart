import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/blocks/list_builder/list_builder_bloc.dart';
import 'package:memory_box/blocks/select_list_builder/select_list_builder_bloc.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/resources/app_coloros.dart';
import 'package:memory_box/widgets/audioplayer/audio_player.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/search.dart';
import 'package:memory_box/widgets/tale_list_tiles/tale_list_tile_with_checkbox.dart';
import 'package:memory_box/widgets/undoButton.dart';

class SelectTalesToPlaylistScreen extends StatefulWidget {
  static const routeName = 'SelectPlaylistTales';

  SelectTalesToPlaylistScreen({
    this.listTaleModels,
    Key? key,
  }) : super(key: key);

  List<TaleModel>? listTaleModels;

  @override
  _SelectTalesToPlaylistScreenState createState() =>
      _SelectTalesToPlaylistScreenState();
}

class _SelectTalesToPlaylistScreenState
    extends State<SelectTalesToPlaylistScreen> {
  String? _searchValue;
  bool _searchHasFocus = false;
  final TextEditingController _searchFieldContoller = TextEditingController();

  void _onSearchValueChange(String value) {
    if (value.endsWith(' ')) return;
    setState(() {
      _searchValue = value;
    });
  }

  void _onSearchValueSelected(String value) {
    // setState(() {
    //   _searchHasFocus = false;

    //   _searchValue = value;

    //   _searchFieldContoller.text = _searchValue ?? '';

    //   FocusScope.of(context).requestFocus(FocusNode());
    // });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _undoChanges() {
      Navigator.of(context).pop();
    }

    void _saveChanges() {
      Navigator.of(context).pop(
          // talesIDs: _taleIDs,
          );
    }

    // void _subscibeTale(TaleModel taleModel) {
    //   widget.listTaleModels?.add(taleModel);
    // }

    // void _unSubscribeTale(TaleModel taleModel) {
    //   widget.listTaleModels?.remove(taleModel);
    // }

    void search(String value) async {
      List<TaleModel> taleModels = await DatabaseService.instance
          .searchTalesByTitle(title: _searchValue);
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SelectListBuilderBloc()
            ..add(
              InitializeSelectListBuilderWithFutureRequest(
                DatabaseService.instance.getAllNotDeletedTaleModels(),
              ),
            ),
        ),
        BlocProvider(
          create: (context) => AudioplayerBloc()
            ..add(
              InitPlayer(),
            ),
        ),
      ],
      child: BackgroundPattern(
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
              undoChanges: _undoChanges,
            ),
            title: Container(
              margin: const EdgeInsets.only(top: 10),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Выбрать',
                  style: TextStyle(
                    fontFamily: 'TTNorms',
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(
                  top: 20,
                  right: 15,
                ),
                child: TextButton(
                  onPressed: _saveChanges,
                  child: const Text(
                    'Добавить',
                    style: TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
            elevation: 0,
          ),
          body: Container(
            margin: const EdgeInsets.only(
              top: 25,
              left: 15,
              right: 15,
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Search(
                  searchFieldContoller: _searchFieldContoller,
                  onChange: _onSearchValueChange,
                  // onFocusChange: _,
                ),
                _searchHasFocus
                    ? const SizedBox(
                        height: 15,
                      )
                    : const SizedBox(
                        height: 50,
                      ),
                Expanded(
                  child: BlocConsumer<SelectListBuilderBloc,
                      SelectListBuilderState>(
                    listener: (context, listBuilderState) {
                      if (listBuilderState is PlaySelectTaleState) {
                        final TaleModel taleModel =
                            listBuilderState.currentPlayTaleModel!;
                        context.read<AudioplayerBloc>().add(
                              Play(
                                taleModel: taleModel,
                                isAutoPlay: true,
                              ),
                            );
                      }

                      if (listBuilderState is StopSelectTaleState) {
                        context.read<AudioplayerBloc>().add(
                              Pause(),
                            );
                      }
                    },
                    builder: (context, listBuilderState) {
                      print('rebuild');
                      return Stack(
                        children: [
                          Expanded(
                            child: listBuilderState.isInit
                                ? ListView.builder(
                                    itemCount: listBuilderState.allTales.length,
                                    itemBuilder: (context, index) {
                                      TaleModel taleModel =
                                          listBuilderState.allTales[index];
                                      bool isPlay = false;
                                      bool isSelected = false;

                                      if (listBuilderState
                                                  .currentPlayTaleModel ==
                                              taleModel &&
                                          listBuilderState.isPlay) {
                                        isPlay = true;
                                      }

                                      listBuilderState.selectedTales
                                          .forEach((value) {
                                        if (value == taleModel) {
                                          isSelected = true;
                                        }
                                      });
                                      print('heh');

                                      return TaleListTileWithCheckBox(
                                        key: UniqueKey(),
                                        isPlayMode: isPlay,
                                        isSelected: isSelected,
                                        taleModel: taleModel,
                                        onPause: () {
                                          context
                                              .read<SelectListBuilderBloc>()
                                              .add(
                                                StopSelectTale(),
                                              );
                                        },
                                        onPlay: () {
                                          context
                                              .read<SelectListBuilderBloc>()
                                              .add(
                                                PlaySelectTale(taleModel),
                                              );
                                        },
                                        subscribeTale: () {
                                          context
                                              .read<SelectListBuilderBloc>()
                                              .add(
                                                SelectTale(taleModel),
                                              );
                                        },
                                        unSubscribeTale: () {
                                          context
                                              .read<SelectListBuilderBloc>()
                                              .add(
                                                UnselectTale(taleModel),
                                              );
                                        },
                                      );
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ),
                          BlocConsumer<AudioplayerBloc, AudioplayerState>(
                            listener: (context, audioPlayerState) {
                              if (audioPlayerState.isTaleEnd) {
                                context.read<AudioplayerBloc>().add(
                                      AnnulAudioPlayer(),
                                    );

                                context.read<SelectListBuilderBloc>().add(
                                      TaleSelectEndPlay(),
                                    );
                              }
                            },
                            builder: (context, audioPlayerState) {
                              if (listBuilderState.currentPlayTaleModel ==
                                  null) {
                                return Container();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: AudioPlayer(
                                    taleModel: audioPlayerState.taleModel,
                                    currentPlayDuration:
                                        audioPlayerState.currentPlayDuration,
                                    isPlay: listBuilderState.isPlay,
                                    isNextButtonAvalible: false,
                                    pause: () {
                                      context.read<SelectListBuilderBloc>().add(
                                            StopSelectTale(),
                                          );
                                    },
                                    play: () {
                                      context.read<SelectListBuilderBloc>().add(
                                            PlaySelectTale(
                                              listBuilderState
                                                  .currentPlayTaleModel!,
                                            ),
                                          );
                                    },
                                    seek: (double durationInMs) {
                                      context.read<AudioplayerBloc>().add(
                                            Seek(
                                              currentPlayTimeInSec:
                                                  durationInMs,
                                            ),
                                          );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
