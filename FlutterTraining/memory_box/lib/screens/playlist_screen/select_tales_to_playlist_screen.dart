import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/blocks/tale_builders/select_list_builder/select_list_builder_bloc.dart';
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

  const SelectTalesToPlaylistScreen({
    this.selectedListTaleModels,
    Key? key,
  }) : super(key: key);

  final List<TaleModel>? selectedListTaleModels;

  @override
  _SelectTalesToPlaylistScreenState createState() =>
      _SelectTalesToPlaylistScreenState();
}

class _SelectTalesToPlaylistScreenState
    extends State<SelectTalesToPlaylistScreen> {
  String? _searchValue;

  late Future<List<TaleModel>> futureRequest;
  final TextEditingController _searchFieldContoller = TextEditingController();

  SelectListBuilderBloc? _selectListBuilderBloc;
  AudioplayerBloc? _audioplayerBloc;
  @override
  void initState() {
    futureRequest =
        DatabaseService.instance.searchTalesByTitle(title: _searchValue);

    super.initState();
  }

  @override
  void dispose() {
    _audioplayerBloc?.add(DisposePlayer());
    super.dispose();
  }

  void _onSearchValueChange(String value) {
    if (value.endsWith(' ')) return;

    setState(() {
      _searchValue = value;

      futureRequest =
          DatabaseService.instance.searchTalesByTitle(title: _searchValue);

      _selectListBuilderBloc?.add(
        InitializeSelectListBuilderWithFutureRequest(
          initializationTales: futureRequest,
        ),
      );
    });
  }

  void _undoChanges() {
    Navigator.of(context).pop(
      widget.selectedListTaleModels,
    );
  }

  void _saveChanges() {
    Navigator.of(context).pop(
      _selectListBuilderBloc?.state.selectedTales,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SelectListBuilderBloc()
            ..add(
              InitializeSelectListBuilderWithFutureRequest(
                initializationTales: futureRequest,
                selectedTaleModels: widget.selectedListTaleModels,
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
              children: [
                const SizedBox(
                  height: 15,
                ),
                Search(
                  searchFieldContoller: _searchFieldContoller,
                  onChange: _onSearchValueChange,
                ),
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: BlocConsumer<SelectListBuilderBloc,
                      SelectListBuilderState>(
                    listener: (context, state) {
                      if (state is PlayTaleState) {
                        final TaleModel taleModel = state.currentPlayTaleModel!;
                        context.read<AudioplayerBloc>().add(
                              Play(
                                taleModel: taleModel,
                                isAutoPlay: true,
                              ),
                            );
                      }

                      if (state is StopTaleState) {
                        context.read<AudioplayerBloc>().add(
                              Pause(),
                            );
                      }
                    },
                    builder: (context, listBuilderState) {
                      _selectListBuilderBloc =
                          context.read<SelectListBuilderBloc>();
                      return Stack(
                        children: [
                          //Secect list
                          RefreshIndicator(
                            onRefresh: () {
                              futureRequest = DatabaseService.instance
                                  .searchTalesByTitle(title: _searchValue);
                              _selectListBuilderBloc?.add(
                                InitializeSelectListBuilderWithFutureRequest(
                                  initializationTales: futureRequest,
                                ),
                              );
                              return Future.value();
                            },
                            child: listBuilderState.isInit
                                ? ListView.builder(
                                    itemCount:
                                        listBuilderState.allTales.length + 1,
                                    itemBuilder: (context, index) {
                                      if (listBuilderState.allTales.length ==
                                          index) {
                                        return const SizedBox(
                                          height: 90,
                                        );
                                      }
                                      TaleModel taleModel =
                                          listBuilderState.allTales[index];
                                      bool isPlayMode = false;
                                      bool isSelected = false;

                                      if (listBuilderState
                                                  .currentPlayTaleModel ==
                                              taleModel &&
                                          listBuilderState.isPlay) {
                                        isPlayMode = true;
                                      }

                                      isSelected = listBuilderState
                                          .selectedTales
                                          .contains(taleModel);

                                      return TaleListTileWithCheckBox(
                                        key: UniqueKey(),
                                        isPlayMode: isPlayMode,
                                        isSelected: isSelected,
                                        taleModel: taleModel,
                                        tooglePlayMode: () =>
                                            _selectListBuilderBloc?.add(
                                          TooglePlayMode(
                                            taleModel: taleModel,
                                          ),
                                        ),
                                        toogleSelectMode: () =>
                                            _selectListBuilderBloc?.add(
                                          ToggleSelectMode(taleModel),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ),
                          //AudioPlayer
                          BlocConsumer<AudioplayerBloc, AudioplayerState>(
                            listener: (context, state) {
                              if (state.isTaleEnd) {
                                context.read<AudioplayerBloc>().add(
                                      AnnulAudioPlayer(),
                                    );
                                _selectListBuilderBloc?.add(
                                  TooglePlayMode(),
                                );
                              }
                            },
                            builder: (context, state) {
                              _audioplayerBloc =
                                  context.read<AudioplayerBloc>();
                              if (state.isTaleInit) {
                                return Container(
                                  alignment: Alignment.bottomCenter,
                                  margin: const EdgeInsets.only(
                                    bottom: 10,
                                  ),
                                  child: AudioPlayer(
                                      taleModel: state.taleModel,
                                      currentPlayPosition:
                                          state.currentPlayPosition,
                                      isPlay: listBuilderState.isPlay,
                                      isNextButtonAvalible: false,
                                      tooglePlayMode: () =>
                                          _selectListBuilderBloc?.add(
                                            TooglePlayMode(
                                              taleModel: state.taleModel,
                                            ),
                                          ),
                                      onSliderChangeEnd: (value) => context
                                          .read<AudioplayerBloc>()
                                          .add(
                                            Seek(currentPlayTimeInSec: value),
                                          ),
                                      // context.read<AudioplayerBloc>().add(
                                      //       EnablePositionNotifyer(),
                                      //     );

                                      onSliderChanged: () => {}
                                      // context.read<AudioplayerBloc>().add(
                                      //       DisablePositionNotifyer(),
                                      //     ),
                                      ),
                                );
                              }
                              return Container();
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
