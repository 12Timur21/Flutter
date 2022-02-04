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

class ToggleSelectMode extends SelectListBuilderEvent {
  final TaleModel taleModel;
  ToggleSelectMode(this.taleModel);
}

class AddFewTalesToPlaylist extends SelectListBuilderEvent {}

class ShareTales extends SelectListBuilderEvent {}

class TooglePlayMode extends SelectListBuilderEvent {
  TaleModel taleModel;

  TooglePlayMode(this.taleModel);
}

class TaleEndPlay extends SelectListBuilderEvent {}
