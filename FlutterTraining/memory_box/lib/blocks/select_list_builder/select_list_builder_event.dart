part of 'select_list_builder_bloc.dart';

abstract class SelectListBuilderEvent {}

class InitializeSelectListBuilderWithFutureRequest
    extends SelectListBuilderEvent {
  InitializeSelectListBuilderWithFutureRequest({
    required this.initializationTales,
    this.selectedTaleModels,
  });
  final Future<List<TaleModel>> initializationTales;
  final List<TaleModel>? selectedTaleModels;
}

class InitializeSelectListBuilderWithTaleModels extends SelectListBuilderEvent {
  InitializeSelectListBuilderWithTaleModels(this.initializationTales);
  final List<TaleModel> initializationTales;
}

class DeleteFewTales extends SelectListBuilderEvent {}

class ToggleSelectMode extends SelectListBuilderEvent {
  ToggleSelectMode(this.taleModel);
  final TaleModel taleModel;
}

class AddFewTalesToPlaylist extends SelectListBuilderEvent {}

class ShareTales extends SelectListBuilderEvent {}

class TooglePlayMode extends SelectListBuilderEvent {
  TooglePlayMode({this.taleModel});
  final TaleModel? taleModel;
}

class TaleEndPlay extends SelectListBuilderEvent {}
