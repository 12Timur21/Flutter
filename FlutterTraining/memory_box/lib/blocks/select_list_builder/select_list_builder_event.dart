part of 'select_list_builder_bloc.dart';

abstract class SelectListBuilderEvent {}

class InitializeSelectListBuilderWithFutureRequest
    extends SelectListBuilderEvent {
  Future<List<TaleModel>> initializationTales;

  InitializeSelectListBuilderWithFutureRequest(this.initializationTales);
}

class InitializeSelectListBuilderWithTaleModels extends SelectListBuilderEvent {
  List<TaleModel> initializationTales;

  InitializeSelectListBuilderWithTaleModels(this.initializationTales);
}

class UpdateSelectListTaleModels extends SelectListBuilderEvent {
  final List<TaleModel> newTaleModels;
  UpdateSelectListTaleModels(this.newTaleModels);
}

class DeleteFewTales extends SelectListBuilderEvent {}

class SelectTale extends SelectListBuilderEvent {
  TaleModel taleModel;
  SelectTale(this.taleModel);
}

class UnselectTale extends SelectListBuilderEvent {
  TaleModel taleModel;
  UnselectTale(this.taleModel);
}

class AddFewTalesToPlaylist extends SelectListBuilderEvent {}

class ShareTales extends SelectListBuilderEvent {}

class PlaySelectTale extends SelectListBuilderEvent {
  TaleModel taleModel;

  PlaySelectTale(this.taleModel);
}

class StopSelectTale extends SelectListBuilderEvent {}

class TaleSelectEndPlay extends SelectListBuilderEvent {}
