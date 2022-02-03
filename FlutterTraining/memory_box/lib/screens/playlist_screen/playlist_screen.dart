import 'package:flutter/material.dart';
import 'package:memory_box/models/playlist_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/resources/app_coloros.dart';
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
  void _createNewPlaylist() {
    Navigator.of(context).pushReplacementNamed(CreatePlaylistScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundPattern(
      patternColor: AppColors.seaNymph,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: ViewingAppBar(
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
                return GridView.count(
                  primary: true,
                  crossAxisCount: 2,
                  childAspectRatio: 190 / 240,
                  children: List.generate(
                    snapshot.data?.length ?? 0,
                    (index) {
                      PlaylistModel playlistModel =
                          PlaylistModel(ID: 'ID', title: '3123123');
                      //!PADDING ВЫНЕСТИ
                      return PlaylistTile(
                        playlistModel: playlistModel,
                        // taleID: snapshot.data?[index].ID ?? '',
                        // title: snapshot.data?[index].title ?? '',
                        // audioCount:
                        //     snapshot.data?[index].taleIDsList?.length ?? 0,
                        // coverUrl: snapshot.data?[index].coverUrl ?? '',
                        // sumAudioDuration:
                        //     snapshot.data?[index].duration ?? Duration.zero,
                        index: index,
                        onTap: () {
                          print('on tap');
                        },
                      );
                    },
                  ),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
