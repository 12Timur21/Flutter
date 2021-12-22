part of 'playListNavigation_bloc.dart';

@immutable
abstract class PlayListNavigationEvent {}

class OpenCollectionsPreviewScreen extends PlayListNavigationEvent {}

class OpenPlayListCreationScreen extends PlayListNavigationEvent {
  final PlayListCreationState? playListCreationState;

  OpenPlayListCreationScreen({
    this.playListCreationState,
  });
}

class OpenPlayListSelectionScreen extends PlayListNavigationEvent {
  final PlayListCreationState? playListCreationState;

  OpenPlayListSelectionScreen({
    this.playListCreationState,
  });
}
