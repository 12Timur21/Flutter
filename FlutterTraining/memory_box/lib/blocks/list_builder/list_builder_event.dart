part of 'list_builder_bloc.dart';

abstract class ListBuilderEvent {}

class InitializeListBuilderWithFutureRequest extends ListBuilderEvent {
  Future<List<TaleModel>> initializationTales;

  InitializeListBuilderWithFutureRequest(this.initializationTales);
}

class InitializeListBuilderWithTaleModels extends ListBuilderEvent {
  List<TaleModel> initializationTales;

  InitializeListBuilderWithTaleModels(this.initializationTales);
}

class DeleteTale extends ListBuilderEvent {
  int index;

  DeleteTale(this.index);
}

class UndoRenameTale extends ListBuilderEvent {}

class RenameTale extends ListBuilderEvent {
  String taleID, newTitle;

  RenameTale(
    this.taleID,
    this.newTitle,
  );
}

class AddTaleToPlaylist extends ListBuilderEvent {}

class PlayTale extends ListBuilderEvent {
  int taleIndex;

  PlayTale(this.taleIndex);
}

class StopTale extends ListBuilderEvent {}

class TaleEndPlay extends ListBuilderEvent {}

class PlayAllTales extends ListBuilderEvent {
  bool isPlayAllTales;

  PlayAllTales(this.isPlayAllTales);
}

class NextTale extends ListBuilderEvent {}
