part of 'list_builder_bloc.dart';

abstract class ListBuilderEvent {}

class InitializeListBuilder extends ListBuilderEvent {
  Future<List<TaleModel>> initializationTales;

  InitializeListBuilder(this.initializationTales);
}

class DeleteTale extends ListBuilderEvent {
  int index;

  DeleteTale(this.index);
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
