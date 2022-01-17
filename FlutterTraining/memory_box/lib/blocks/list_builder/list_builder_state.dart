part of 'list_builder_bloc.dart';

class ListBuilderState {
  final bool isInit;
  final List<TaleModel>? allTales;
  final List<TaleModel>? selectedTales;

  final int? currentPlayTaleIndex;

  ListBuilderState({
    this.allTales,
    this.selectedTales,
    this.currentPlayTaleIndex,
    this.isInit = false,
  });

  ListBuilderState copyWith({
    List<TaleModel>? allTales,
    List<TaleModel>? SelectedTales,
    int? currentPlayTaleIndex,
    bool? isInit,
  }) {
    return ListBuilderState(
      allTales: allTales ?? this.allTales,
      selectedTales: selectedTales ?? this.selectedTales,
      currentPlayTaleIndex: currentPlayTaleIndex ?? this.currentPlayTaleIndex,
      isInit: isInit ?? this.isInit,
    );
  }
}
