part of 'list_builder_bloc.dart';

abstract class ListBuilderEvent {}

class InitializeListBuilder extends ListBuilderEvent {
  Future<List<TaleModel>> initializationTales;

  InitializeListBuilder(this.initializationTales);
}

class DeleteTale extends ListBuilderEvent {
  String taleID;

  DeleteTale(this.taleID);
}

class DeleteFewTales extends ListBuilderEvent {}

class SelectTale extends ListBuilderEvent {}

class UndoRenameTale extends ListBuilderEvent {}

class RenameTale extends ListBuilderEvent {
  String taleID, newTitle;

  RenameTale(
    this.taleID,
    this.newTitle,
  );
}

class AddTaleToPlaylist extends ListBuilderEvent {}

class ShareTale extends ListBuilderEvent {
  String taleUrl;

  ShareTale(this.taleUrl);
}

class PlayTale extends ListBuilderEvent {
  String taleID;

  PlayTale(this.taleID);
}

class StopTale extends ListBuilderEvent {
  String taleID;

  StopTale(this.taleID);
}

class PlayAllTales extends ListBuilderEvent {}
