part of 'playlist_builder_bloc.dart';

class PlaylistBuilderState extends Equatable {
  final bool isInit;
  final bool isSelectMode;

  final List<PlaylistModel> allPlaylists;
  final List<PlaylistModel> selectedPlaylists;

  const PlaylistBuilderState({
    this.isInit = false,
    this.isSelectMode = false,
    this.allPlaylists = const [],
    this.selectedPlaylists = const [],
  });

  PlaylistBuilderState copyWith({
    bool? isInit,
    bool? isSelectMode,
    List<PlaylistModel>? allPlaylists,
    List<PlaylistModel>? selectedPlaylists,
  }) {
    return PlaylistBuilderState(
      isInit: isInit ?? this.isInit,
      isSelectMode: isSelectMode ?? this.isSelectMode,
      allPlaylists: allPlaylists ?? this.allPlaylists,
      selectedPlaylists: selectedPlaylists ?? this.selectedPlaylists,
    );
  }

  @override
  List<Object?> get props => [
        isInit,
        isSelectMode,
        allPlaylists,
        selectedPlaylists,
      ];
}
