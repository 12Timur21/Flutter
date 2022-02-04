import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
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

  const SelectTalesToPlaylistScreen({
    this.listTaleModels,
    Key? key,
  }) : super(key: key);

  final List<TaleModel>? listTaleModels;

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

  void _undoChanges() {
    Navigator.of(context).pop();
  }

  void _saveChanges() {
    Navigator.of(context).pop(
        // talesIDs: _taleIDs,
        );
  }

  void _search(String value) async {
    List<TaleModel> taleModels =
        await DatabaseService.instance.searchTalesByTitle(title: _searchValue);
  }

  @override
  Widget build(BuildContext context) {
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
                  child: BlocBuilder<SelectListBuilderBloc,
                      SelectListBuilderState>(
                    // listener: (context, listBuilderState) {
                    //   // if (listBuilderState is PlaySelectTaleState) {
                    //   //   final TaleModel taleModel =
                    //   //       listBuilderState.currentPlayTaleModel!;
                    //   //   context.read<AudioplayerBloc>().add(
                    //   //         Play(
                    //   //           taleModel: taleModel,
                    //   //           isAutoPlay: true,
                    //   //         ),
                    //   //       );
                    //   // }

                    //   // if (listBuilderState is StopSelectTaleState) {
                    //   //   context.read<AudioplayerBloc>().add(
                    //   //         Pause(),
                    //   //       );
                    //   // }
                    // },
                    builder: (context, listBuilderState) {
                      return listBuilderState.isInit
                          ? ListView.builder(
                              itemCount: listBuilderState.allTales.length,
                              itemBuilder: (context, index) {
                                TaleModel taleModel =
                                    listBuilderState.allTales[index];
                                bool isPlay = false;
                                bool isSelected = false;

                                // if (listBuilderState.currentPlayTaleModel ==
                                //         taleModel &&
                                //     listBuilderState.isPlay) {
                                //   isPlay = true;
                                // }

                                for (final TaleModel value
                                    in listBuilderState.selectedTales) {
                                  if (value == taleModel) {
                                    isSelected = true;
                                    log(value.toString());
                                    break;
                                  }
                                }

                                return TaleListTileWithCheckBox(
                                    key: UniqueKey(),
                                    isPlayMode: isPlay,
                                    isSelected: isSelected,
                                    taleModel: taleModel,
                                    tooglePlayMode: () {
                                      context.read<SelectListBuilderBloc>().add(
                                            TooglePlayMode(taleModel),
                                          );
                                    },
                                    toogleSelectMode: () {
                                      context.read<SelectListBuilderBloc>().add(
                                            ToggleSelectMode(taleModel),
                                          );
                                    });
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
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
