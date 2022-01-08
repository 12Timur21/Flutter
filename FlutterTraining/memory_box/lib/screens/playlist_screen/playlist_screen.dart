import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/models/play_list_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/screens/home_screen/home_screen.dart';
import 'package:memory_box/screens/playlist_screen/create_playlist_screen.dart';
import 'package:memory_box/utils/formatting.dart';
import 'package:memory_box/utils/navigationService.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';

class PlaylistScreen extends StatefulWidget {
  static const routeName = 'PlayListScreen';

  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  void createNewCollection() {
    NavigationService.instance.navigateTo(CreatePlaylistScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    Widget CollectionTile({
      required String title,
      required int audioCount,
      required Duration sumAudioDuration,
      required String coverUrl,
      required int index,
    }) {
      EdgeInsets margin = index % 2 == 0
          ? const EdgeInsets.only(
              top: 20,
              left: 15,
              right: 8,
            )
          : const EdgeInsets.only(
              top: 20,
              right: 15,
              left: 8,
            );

      return Container(
        height: 240,
        width: 190,
        margin: margin,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: coverUrl,
                    height: 240,
                    fit: BoxFit.fill,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color.fromRGBO(0, 0, 0, 0),
                          Color.fromRGBO(69, 69, 69, 1),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                    left: 15,
                    right: 15,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'TTNorms',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$audioCount аудио',
                            style: const TextStyle(
                              fontFamily: 'TTNorms',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            '${convertDurationToString(
                              duration: sumAudioDuration,
                              formattingType:
                                  TimeFormattingType.hourMinuteWithOneDigits,
                            )} часа',
                            style: const TextStyle(
                              fontFamily: 'TTNorms',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    return BackgroundPattern(
      patternColor: const Color.fromRGBO(113, 165, 159, 1),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          primary: true,
          toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: Container(
            margin: const EdgeInsets.only(left: 6),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/Plus.svg',
              ),
              onPressed: () {
                createNewCollection();
              },
            ),
          ),
          title: Container(
            margin: const EdgeInsets.only(top: 10),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'Подборки',
                style: TextStyle(
                  fontFamily: 'TTNorms',
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                  letterSpacing: 0.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '\n Все в одном месте',
                    style: TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(
                right: 15,
              ),
              child: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/More.svg',
                ),
              ),
            )
          ],
          elevation: 0,
        ),
        body: Container(
            margin: const EdgeInsets.only(
              top: 30,
            ),
            child: FutureBuilder<List<PlayListModel>>(
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
                        return CollectionTile(
                          title: snapshot.data?[index].title ?? '',
                          audioCount: 5,
                          coverUrl: snapshot.data?[index].coverUrl ?? '',
                          sumAudioDuration: const Duration(hours: 4),
                          index: index,
                        );
                      },
                    ),
                  );
                }
                return CircularProgressIndicator();
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
