part of 'list_builder_bloc.dart';

class ListBuilderState {
  final bool isInit;
  final bool isPlay;
  final bool isPlayAllTalesMode;

  final List<TaleModel>? allTales;

  final int? currentPlayTaleIndex;

  ListBuilderState({
    this.isInit = false,
    this.isPlay = false,
    this.isPlayAllTalesMode = false,
    this.allTales,
    this.currentPlayTaleIndex,
  });

  ListBuilderState copyWith({
    bool? isInit,
    bool? isPlay,
    bool? isPlayAllTalesMode,
    List<TaleModel>? allTales,
    List<TaleModel>? selectedTales,
    int? currentPlayTaleIndex,
  }) {
    return ListBuilderState(
      isInit: isInit ?? this.isInit,
      isPlay: isPlay ?? this.isPlay,
      isPlayAllTalesMode: isPlayAllTalesMode ?? this.isPlayAllTalesMode,
      allTales: allTales ?? this.allTales,
      currentPlayTaleIndex: currentPlayTaleIndex ?? this.currentPlayTaleIndex,
    );
  }
}

class PlayTaleState extends ListBuilderState {
  PlayTaleState({
    required bool isInit,
    required bool isPlay,
    required bool isPlayAllTalesMode,
    List<TaleModel>? allTales,
    required int? currentPlayTaleIndex,
  }) : super(
          isInit: isInit,
          isPlay: isPlay,
          isPlayAllTalesMode: isPlayAllTalesMode,
          allTales: allTales,
          currentPlayTaleIndex: currentPlayTaleIndex,
        );
}

class StopTaleState extends ListBuilderState {
  StopTaleState({
    required bool isInit,
    required bool isPlay,
    required bool isPlayAllTalesMode,
    List<TaleModel>? allTales,
    required int? currentPlayTaleIndex,
  }) : super(
          isInit: isInit,
          isPlay: isPlay,
          isPlayAllTalesMode: isPlayAllTalesMode,
          allTales: allTales,
          currentPlayTaleIndex: currentPlayTaleIndex,
        );
}
