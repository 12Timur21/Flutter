import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'playListNavigation_event.dart';
part 'playListNavigation_state.dart';

class PlayListNavigationBloc
    extends Bloc<PlayListNavigationEvent, PlayListNavigationState> {
  PlayListNavigationBloc() : super(PlayListPreviewScreen()) {
    on<OpenCollectionsPreviewScreen>((
      event,
      Emitter<PlayListNavigationState> emit,
    ) {
      emit(
        PlayListPreviewScreen(),
      );
    });
    on<OpenPlayListCreationScreen>((
      event,
      Emitter<PlayListNavigationState> emit,
    ) {
      emit(
        PlayListCreationScreen(
          playListCreationState: event.playListCreationState,
        ),
      );
    });
    on<OpenPlayListSelectionScreen>((
      event,
      Emitter<PlayListNavigationState> emit,
    ) {
      emit(
        PlayListSelectionScreen(
          playListCreationState: event.playListCreationState,
        ),
      );
    });
  }
}
