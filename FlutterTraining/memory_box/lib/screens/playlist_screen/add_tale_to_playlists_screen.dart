import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/playlist_builder/playlist_builder_bloc.dart';
import 'package:memory_box/models/playlist_model.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/resources/app_coloros.dart';
import 'package:memory_box/screens/playlist_screen/create_playlist_screen.dart';
import 'package:memory_box/screens/playlist_screen/widgets/appBars/selection_appbar.dart';
import 'package:memory_box/screens/playlist_screen/widgets/tiles/playlist_tile.dart';
import 'package:memory_box/screens/playlist_screen/widgets/tiles/select_playtlist_tile.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';

class AddTaleToPlaylists extends StatefulWidget {
  static const routeName = 'AddTaleToPlaylists';

  const AddTaleToPlaylists({
    required this.taleModels,
    Key? key,
  }) : super(key: key);

  final List<TaleModel> taleModels;

  @override
  _AddTaleToPlaylistsState createState() => _AddTaleToPlaylistsState();
}

class _AddTaleToPlaylistsState extends State<AddTaleToPlaylists> {
  final PlaylistBuilderBloc _playlistBuilderBloc = PlaylistBuilderBloc();

  @override
  void initState() {
    _playlistBuilderBloc.add(
      InitializePlaylistBuilderWithFutureRequest(
        initializationPlaylistRequest:
            DatabaseService.instance.getAllPlayList(),
      ),
    );
    _playlistBuilderBloc.add(ToogleSelectMode());
    super.initState();
  }

  Future<void> _createNewPlaylist() async {
    PlaylistModel? _newPlaylistModel = await Navigator.of(context).pushNamed(
      CreatePlaylistScreen.routeName,
    ) as PlaylistModel?;

    if (_newPlaylistModel != null) {
      _playlistBuilderBloc.add(
        AddNewPlaylist(
          playlistModel: _newPlaylistModel,
        ),
      );
    }
  }

  void _addTalesToPlaylist() async {
    await DatabaseService.instance.addTalesToFewPlaylist(
      playlistModels: _playlistBuilderBloc.state.selectedPlaylists,
      taleModels: [...widget.taleModels],
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundPattern(
      patternColor: AppColors.seaNymph,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: SelectionAppBar(
          addTalesToPlaylist: _addTalesToPlaylist,
          createNewPlaylist: _createNewPlaylist,
        ),
        body: Container(
          margin: const EdgeInsets.only(
            top: 30,
          ),
          child: BlocConsumer<PlaylistBuilderBloc, PlaylistBuilderState>(
            bloc: _playlistBuilderBloc,
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
                    bool isSelected = state.selectedPlaylists
                            .contains(state.allPlaylists[index])
                        ? true
                        : false;
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
                      child: SelectPlaylistTile(
                        key: UniqueKey(),
                        isSelected: isSelected,
                        onSelect: () => _playlistBuilderBloc.add(
                          ToogleSelectPlaylisy(
                            playlistModel: state.allPlaylists[index],
                          ),
                        ),
                        playlistModel: state.allPlaylists[index],
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // FutureBuilder<List<PlaylistModel>>(
          //   future: DatabaseService.instance.getAllPlayList(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       print(snapshot.data);
          //       return GridView.count(
          //         primary: true,
          //         crossAxisCount: 2,
          //         childAspectRatio: 190 / 240,
          //         children: List.generate(
          //           snapshot.data?.length ?? 0,
          //           (index) {
          //             return SelectPlaylistTile(
          //               taleID: snapshot.data?[index].ID ?? '',
          //               title: snapshot.data?[index].title ?? '',
          //               audioCount:
          //                   snapshot.data?[index].taleModels.length ?? 0,
          //               coverUrl: snapshot.data?[index].coverUrl ?? '',
          //               sumAudioDuration: Duration.zero,
          //               // snapshot.data?[index].duration ?? Duration.zero,
          //               index: index,
          //               onSelelct: _onSelectTile,
          //               onUnselect: _onUnselectTile,
          //             );
          //           },
          //         ),
          //       );
          //     }
          //     return const CircularProgressIndicator();
          //   },
          // )
          // child: FutureBuilder(
          //   future: DatabaseService.instance.getAllPlayList(),
          //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //     // print(snapshot.data);
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       return
          //     } else {
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //   },
          // ),
        ),
      ),
    );
  }
}
