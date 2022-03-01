import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/playlist_builder/playlist_builder_bloc.dart';
import 'package:memory_box/models/playlist_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/resources/app_coloros.dart';
import 'package:memory_box/screens/playlist_screen/detailed_playlist_screen.dart';
import 'package:memory_box/screens/playlist_screen/widgets/appBars/viewing_appbar.dart';
import 'package:memory_box/screens/playlist_screen/widgets/tiles/playlist_tile.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'create_playlist_screen.dart';

class PlaylistScreen extends StatefulWidget {
  static const routeName = 'PlayListScreen';

  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  Future<void> _createNewPlaylist({
    required BuildContext context,
  }) async {
    PlaylistModel? _newPlaylistModel = await Navigator.of(context).pushNamed(
      CreatePlaylistScreen.routeName,
    ) as PlaylistModel?;

    if (_newPlaylistModel != null) {
      context.read<PlaylistBuilderBloc>().add(
            AddNewPlaylist(
              playlistModel: _newPlaylistModel,
            ),
          );
    }
  }

  Future<void> _openPlaylist({
    required PlaylistModel playlistModel,
    required BuildContext context,
  }) async {
    PlaylistModel? updatedPlaylistModel = await Navigator.of(context).pushNamed(
      DetailedPlaylistScreen.routeName,
      arguments: playlistModel,
    ) as PlaylistModel?;

    final playlistBuilderBloc = context.read<PlaylistBuilderBloc>();

    if (updatedPlaylistModel != null) {
      playlistBuilderBloc.add(
        UpdateCurrentPlaylist(
          updatedPlaylistModel,
        ),
      );
    } else {
      playlistBuilderBloc.add(
        DeleteFewPlaylists(
          playlistModels: [playlistModel],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaylistBuilderBloc()
        ..add(
          InitializePlaylistBuilderWithFutureRequest(
            initializationPlaylistRequest:
                DatabaseService.instance.getAllPlayList(),
          ),
        ),
      child: Builder(
        builder: (context) {
          return BackgroundPattern(
            patternColor: AppColors.seaNymph,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              appBar: ViewingAppBar(
                createNewPlaylist: () {
                  _createNewPlaylist(
                    context: context,
                  );
                },
              ),
              body: Container(
                margin: const EdgeInsets.only(
                  top: 30,
                ),
                child: BlocConsumer<PlaylistBuilderBloc, PlaylistBuilderState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (!state.isInit) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.count(
                      primary: true,
                      crossAxisCount: 2,
                      childAspectRatio: 190 / 240,
                      children: List.generate(
                        state.allPlaylists.length,
                        (index) {
                          return Container(
                            margin: index % 2 == 0
                                ? const EdgeInsets.only(
                                    top: 20,
                                    left: 15,
                                    right: 8,
                                  )
                                : const EdgeInsets.only(
                                    top: 20,
                                    right: 15,
                                    left: 8,
                                  ),
                            child: PlaylistTile(
                              key: UniqueKey(),
                              playlistModel: state.allPlaylists[index],
                              onTap: () {
                                _openPlaylist(
                                  playlistModel: state.allPlaylists[index],
                                  context: context,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
