import 'package:flutter/material.dart';
import 'package:memory_box/models/playlist_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/resources/app_coloros.dart';
import 'package:memory_box/screens/playlist_screen/create_playlist_screen.dart';
import 'package:memory_box/screens/playlist_screen/widgets/appBars/selection_appbar.dart';
import 'package:memory_box/screens/playlist_screen/widgets/tiles/select_playtlist_tile.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';

class AddTaleToPlaylists extends StatefulWidget {
  const AddTaleToPlaylists({
    required this.taleID,
    Key? key,
  }) : super(key: key);

  final String taleID;

  @override
  _AddTaleToPlaylistsState createState() => _AddTaleToPlaylistsState();
}

class _AddTaleToPlaylistsState extends State<AddTaleToPlaylists> {
  void _createNewPlaylist() {
    Navigator.of(context).pushReplacementNamed(CreatePlaylistScreen.routeName);
  }

  //*[START] AdditionTaleToPlaylistMode
  List<String> selectedTileIDs = [];

  void _onSelectTile(String tileID) {
    selectedTileIDs.add(tileID);
  }

  void _onUnselectTile(String tileID) {
    selectedTileIDs.remove(tileID);
  }

  void _addTalesToPlaylist() async {
    String? taleID = widget.taleID;

    await DatabaseService.instance.addTalesToFewPlaylist(
      playlistIDs: selectedTileIDs,
      taleIDs: [taleID],
    );

    Navigator.of(context).pop();
  }
  //*[END] AdditionTaleToPlaylistMode

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
            child: FutureBuilder<List<PlaylistModel>>(
              future: DatabaseService.instance.getAllPlayList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print(snapshot.data);
                  return GridView.count(
                    primary: true,
                    crossAxisCount: 2,
                    childAspectRatio: 190 / 240,
                    children: List.generate(
                      snapshot.data?.length ?? 0,
                      (index) {
                        return SelectPlaylistTile(
                          taleID: snapshot.data?[index].ID ?? '',
                          title: snapshot.data?[index].title ?? '',
                          audioCount:
                              snapshot.data?[index].taleModels.length ?? 0,
                          coverUrl: snapshot.data?[index].coverUrl ?? '',
                          sumAudioDuration: Duration.zero,
                          // snapshot.data?[index].duration ?? Duration.zero,
                          index: index,
                          onSelelct: _onSelectTile,
                          onUnselect: _onUnselectTile,
                        );
                      },
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
            )
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
