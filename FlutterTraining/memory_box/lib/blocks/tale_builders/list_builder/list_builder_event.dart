part of 'list_builder_bloc.dart';

abstract class ListBuilderEvent {}

class InitializeListBuilderWithFutureRequest extends ListBuilderEvent {
  Future<List<TaleModel>> initializationTales;

  InitializeListBuilderWithFutureRequest(this.initializationTales);
}

class InitializeListBuilderWithTaleModels extends ListBuilderEvent {
  List<TaleModel>? initializationTales;

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

class TooglePlayMode extends ListBuilderEvent {
  TooglePlayMode({this.taleModel});
  final TaleModel? taleModel;
}

class TooglePlayAllMode extends ListBuilderEvent {
  TooglePlayAllMode();
}

class NextTale extends ListBuilderEvent {}
