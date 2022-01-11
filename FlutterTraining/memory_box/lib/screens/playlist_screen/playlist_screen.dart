import 'package:flutter/material.dart';

import 'package:memory_box/models/playlist_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/screens/playlist_screen/select_playlist_tales.dart';
import 'package:memory_box/screens/playlist_screen/widgets/appBars/selection_appbar.dart';
import 'package:memory_box/screens/playlist_screen/widgets/appBars/viewing_appbar.dart';

import 'package:memory_box/screens/playlist_screen/widgets/tiles/playlist_tile.dart';
import 'package:memory_box/screens/playlist_screen/widgets/tiles/select_playtlist_tile.dart';
import 'package:memory_box/utils/navigationService.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';

import 'create_playlist_screen.dart';

class PlaylistScreen extends StatefulWidget {
  static const routeName = 'PlayListScreen';

  const PlaylistScreen({
    this.taleID,
    Key? key,
  }) : super(key: key);

  final String? taleID;

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  bool isAdditionTaleToPlaylistMode = false;

  @override
  void initState() {
    if (widget.taleID != null) {
      isAdditionTaleToPlaylistMode = true;
    }
    super.initState();
  }

  void _createNewPlaylist() {
    NavigationService.instance.navigateTo(
      CreatePlaylistScreen.routeName,
    );
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
    if (taleID != null) {
      await DatabaseService.instance.addOneTaleToFewPlaylist(
        playListIDs: selectedTileIDs,
        taleID: taleID,
      );
    }
    NavigationService.instance.navigateToPreviousPage();
  }
  //*[END] AdditionTaleToPlaylistMode

  @override
  Widget build(BuildContext context) {
    return BackgroundPattern(
      patternColor: const Color.fromRGBO(113, 165, 159, 1),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: (isAdditionTaleToPlaylistMode
            ? SelectionAppBar(
                addTalesToPlaylist: _addTalesToPlaylist,
                createNewPlaylist: _createNewPlaylist,
              )
            : ViewingAppBar(
                createNewPlaylist: _createNewPlaylist,
              )) as PreferredSizeWidget,
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
                        //!!!УБРАТЬ
                        return isAdditionTaleToPlaylistMode
                            ? SelectPlaylistTile(
                                taleID: snapshot.data?[index].ID ?? '',
                                title: snapshot.data?[index].title ?? '',
                                audioCount:
                                    snapshot.data?[index].taleIDsList?.length ??
                                        0,
                                coverUrl: snapshot.data?[index].coverUrl ?? '',
                                sumAudioDuration:
                                    snapshot.data?[index].duration ??
                                        Duration.zero,
                                index: index,
                                onSelelct: _onSelectTile,
                                onUnselect: _onUnselectTile,
                              )
                            : PlaylistTile(
                                taleID: snapshot.data?[index].ID ?? '',
                                title: snapshot.data?[index].title ?? '',
                                audioCount:
                                    snapshot.data?[index].taleIDsList?.length ??
                                        0,
                                coverUrl: snapshot.data?[index].coverUrl ?? '',
                                sumAudioDuration:
                                    snapshot.data?[index].duration ??
                                        Duration.zero,
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
