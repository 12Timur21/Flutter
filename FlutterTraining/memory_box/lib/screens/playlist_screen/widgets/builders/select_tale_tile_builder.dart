import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/blocks/tale_builders/select_list_builder/select_list_builder_bloc.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/widgets/audioplayer/audio_player.dart';
import 'package:memory_box/widgets/tale_list_tiles/tale_list_tile_with_checkbox.dart';

class SelectTaleTileBuilder extends StatefulWidget {
  const SelectTaleTileBuilder({
    required this.selectListBuilderBloc,
    required this.audioplayerBloc,
    required this.onAddTalesButtonPressed,
    required this.onFocus,
    Key? key,
  }) : super(key: key);
  final SelectListBuilderBloc selectListBuilderBloc;
  final AudioplayerBloc audioplayerBloc;
  final VoidCallback onAddTalesButtonPressed;
  final VoidCallback onFocus;
  @override
  _SelectTaleTileBuilderState createState() => _SelectTaleTileBuilderState();
}

class _SelectTaleTileBuilderState extends State<SelectTaleTileBuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelectListBuilderBloc, SelectListBuilderState>(
      bloc: widget.selectListBuilderBloc,
      listener: (context, state) {
        if (state is PlayTaleState) {
          final TaleModel taleModel = state.currentPlayTaleModel!;
          widget.audioplayerBloc.add(
            Play(
              taleModel: taleModel,
              isAutoPlay: true,
            ),
          );
        }

        if (state is StopTaleState) {
          widget.audioplayerBloc.add(
            Pause(),
          );
        }
      },
      builder: (context, listBuilderState) {
        return Stack(
          children: [
            //LIST
            if (widget.selectListBuilderBloc.state.allTales.isNotEmpty) ...[
              ListView.builder(
                itemCount: listBuilderState.allTales.length + 1,
                itemBuilder: (context, index) {
                  if (listBuilderState.allTales.length == index) {
                    return const SizedBox(
                      height: 90,
                    );
                  }
                  final TaleModel taleModel = listBuilderState.allTales[index];
                  bool isPlayMode = false;
                  bool isSelected = false;

                  if (listBuilderState.currentPlayTaleModel == taleModel &&
                      listBuilderState.isPlay) {
                    isPlayMode = true;
                  }

                  isSelected =
                      listBuilderState.selectedTales.contains(taleModel);

                  return TaleListTileWithCheckBox(
                    key: UniqueKey(),
                    isPlay: isPlayMode,
                    isSelected: isSelected,
                    taleModel: taleModel,
                    tooglePlayMode: () {
                      widget.selectListBuilderBloc.add(
                        TooglePlayMode(
                          taleModel: taleModel,
                        ),
                      );
                    },
                    toogleSelectMode: () {
                      widget.selectListBuilderBloc.add(
                        ToggleSelectMode(taleModel),
                      );
                    },
                  );
                },
              )
              // : const Center(
              //     child: CircularProgressIndicator(),
              //   ),
              // },
              // )
            ] else ...[
              Center(
                child: TextButton(
                  onPressed: widget.onAddTalesButtonPressed,
                  child: const Text(
                    'Тут пока нет записей',
                    style: TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.transparent,
                      decoration: TextDecoration.underline,
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
            ],
            //AudioPlayer
            BlocConsumer<AudioplayerBloc, AudioplayerState>(
              bloc: widget.audioplayerBloc,
              listener: (context, state) {
                if (state.isTaleEnd) {
                  widget.selectListBuilderBloc.add(
                    TooglePlayMode(),
                  );
                  widget.audioplayerBloc.add(
                    AnnulAudioPlayer(),
                  );
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
                      isPlay: listBuilderState.isPlay,
                      isNextButtonAvalible: false,
                      tooglePlayMode: () {
                        widget.selectListBuilderBloc.add(
                          TooglePlayMode(
                            taleModel: state.taleModel,
                          ),
                        );
                      },
                      onSliderChangeEnd: (value) {
                        widget.audioplayerBloc.add(
                          Seek(currentPlayTimeInSec: value),
                        );
                      },
                      onSliderChanged: () => {},
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        );
      },
    );
  }
}
