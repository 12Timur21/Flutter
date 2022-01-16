part of 'list_builder_bloc.dart';

class ListBuilderState {}

class NotInitializedListBuilderState extends ListBuilderState {}

class InitializedListBuilderState extends ListBuilderState {
  List<TaleModel>? allTales;
  List<TaleModel>? selectedTales;

  int currentPlayTale;

  InitializedListBuilderState({
    this.allTales,
    this.selectedTales,
    this.currentPlayTale = 0,
  });

  ListBuilderState copyWith({
    List<TaleModel>? newAllTales,
    List<TaleModel>? newSelectedTales,
    int? newCurrentPlayTale,
  }) {
    return InitializedListBuilderState(
      allTales: newAllTales ?? allTales,
      selectedTales: selectedTales ?? newSelectedTales,
      currentPlayTale: newCurrentPlayTale ?? currentPlayTale,
    );
  }
}
