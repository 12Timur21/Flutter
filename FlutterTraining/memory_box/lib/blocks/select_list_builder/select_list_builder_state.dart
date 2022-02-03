part of 'select_list_builder_bloc.dart';

class SelectListBuilderState extends Equatable {
  final bool isInit;
  final bool isPlay;

  final List<TaleModel> allTales;
  final List<TaleModel> selectedTales;

  final TaleModel? currentPlayTaleModel;

  const SelectListBuilderState({
    this.isInit = false,
    this.isPlay = false,
    this.allTales = const [],
    this.selectedTales = const [],
    this.currentPlayTaleModel,
  });

  SelectListBuilderState copyWith({
    bool? isInit,
    bool? isPlay,
    List<TaleModel>? allTales,
    List<TaleModel>? selectedTales,
    TaleModel? currentPlayTaleModel,
  }) {
    return SelectListBuilderState(
      isInit: isInit ?? this.isInit,
      isPlay: isPlay ?? this.isPlay,
      allTales: allTales ?? this.allTales,
      selectedTales: selectedTales ?? this.selectedTales,
      currentPlayTaleModel: currentPlayTaleModel ?? this.currentPlayTaleModel,
    );
  }

  @override
  List<Object?> get props => [
        isInit,
        isPlay,
        allTales,
        selectedTales,
        currentPlayTaleModel,
      ];
}

class PlaySelectTaleState extends SelectListBuilderState {
  const PlaySelectTaleState({
    required bool isInit,
    required bool isPlay,
    required List<TaleModel> allTales,
    required List<TaleModel> selectedTales,
    required TaleModel? currentPlayTaleModel,
  }) : super(
          isInit: isInit,
          isPlay: isPlay,
          allTales: allTales,
          selectedTales: selectedTales,
          currentPlayTaleModel: currentPlayTaleModel,
        );
}

class StopSelectTaleState extends SelectListBuilderState {
  const StopSelectTaleState({
    required bool isInit,
    required bool isPlay,
    required List<TaleModel> allTales,
    required List<TaleModel> selectedTales,
    required TaleModel? currentPlayTaleModel,
  }) : super(
          isInit: isInit,
          isPlay: isPlay,
          allTales: allTales,
          selectedTales: selectedTales,
          currentPlayTaleModel: currentPlayTaleModel,
        );
}
