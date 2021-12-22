part of 'playListNavigation_bloc.dart';

class PlayListCreationState {
  String? title;
  File? photo;
  String? description;
  List<String>? talesIDs;

  PlayListCreationState({
    this.title,
    this.photo,
    this.description,
    this.talesIDs,
  });
}

@immutable
abstract class PlayListNavigationState {}

class PlayListPreviewScreen extends PlayListNavigationState {}

class PlayListCreationScreen extends PlayListNavigationState {
  PlayListCreationState? playListCreationState;

  PlayListCreationScreen({
    this.playListCreationState,
  });
}

class PlayListSelectionScreen extends PlayListNavigationState {
  PlayListCreationState? playListCreationState;

  PlayListSelectionScreen({
    this.playListCreationState,
  });
}
