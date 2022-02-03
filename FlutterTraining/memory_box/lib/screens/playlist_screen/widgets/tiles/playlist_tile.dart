import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/models/playlist_model.dart';
import 'package:memory_box/resources/app_coloros.dart';

class PlaylistTile extends StatefulWidget {
  const PlaylistTile({
    // required this.playlistID,
    // required this.title,
    // required this.audioCount,
    // required this.sumAudioDuration,
    // required this.coverUrl,
    required this.playlistModel,
    required this.index,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  // final String playlistID;
  // final String title;
  // final int audioCount;
  // final Duration sumAudioDuration;
  // final String coverUrl;
  final PlaylistModel playlistModel;
  final int index;

  final VoidCallback onTap;

  @override
  _PlaylistTileState createState() => _PlaylistTileState();
}

class _PlaylistTileState extends State<PlaylistTile> {
  bool isSelect = false;

  @override
  Widget build(BuildContext context) {
    EdgeInsets margin = widget.index % 2 == 0
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

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
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
                    imageUrl: widget.playlistModel.coverURL ??
                        'https://lightning.od-cdn.com/static/img/no-cover_en_US.a8920a302274ea37cfaecb7cf318890e.jpg',
                    height: 240,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.black,
                          AppColors.gray,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        const Spacer(),
                        Padding(
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
                                  widget.playlistModel.title,
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
                                    '${widget.playlistModel.taleModels?.length ?? 0} аудио',
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
                                  // Text(
                                  //   // sumAudioDuration?.inMilliseconds.toString() ?? '',
                                  //   '${convertDurationToString(
                                  //     duration: widget.sumAudioDuration,
                                  //     formattingType:
                                  //         TimeFormattingType.hourMinute,
                                  //   )} ${widget.sumAudioDuration.inHours > 0 ? "часа" : "минут"}',
                                  //   style: const TextStyle(
                                  //     fontFamily: 'TTNorms',
                                  //     fontWeight: FontWeight.w400,
                                  //     fontSize: 12,
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
