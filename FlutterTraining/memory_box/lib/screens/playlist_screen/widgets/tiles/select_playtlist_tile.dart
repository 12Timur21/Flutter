import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/utils/formatting.dart';

class SelectPlaylistTile extends StatefulWidget {
  const SelectPlaylistTile({
    required this.taleID,
    required this.title,
    required this.audioCount,
    required this.sumAudioDuration,
    required this.coverUrl,
    required this.index,
    required this.onSelelct,
    required this.onUnselect,
    Key? key,
  }) : super(key: key);

  final String taleID;
  final String title;
  final int audioCount;
  final Duration sumAudioDuration;
  final String coverUrl;
  final int index;

  final Function(String) onSelelct;
  final Function(String) onUnselect;

  @override
  _SelectPlaylistTileState createState() => _SelectPlaylistTileState();
}

class _SelectPlaylistTileState extends State<SelectPlaylistTile> {
  bool isSelect = false;

  void _toogleTile() {
    setState(() {
      isSelect = !isSelect;

      if (isSelect) {
        widget.onSelelct(widget.taleID);
      } else {
        widget.onUnselect(widget.taleID);
      }
    });
    print(isSelect);
  }

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
      onTap: _toogleTile,
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
                    imageUrl: widget.coverUrl,
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
                    child: Stack(
                      children: [
                        Column(
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
                                      widget.title,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${widget.audioCount} аудио',
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
                                        // sumAudioDuration?.inMilliseconds.toString() ?? '',
                                        '${convertDurationToString(
                                          duration: widget.sumAudioDuration,
                                          formattingType: TimeFormattingType
                                              .hourMinuteWithOneDigits,
                                        )} ${widget.sumAudioDuration.inHours > 0 ? "часа" : "минут"}',
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
                        ),
                        Container(
                          color: isSelect
                              ? null
                              : const Color.fromRGBO(0, 0, 0, 0.4),
                          child: Center(
                            child: isSelect
                                ? SvgPicture.asset(
                                    'assets/icons/SubmitCircle.svg',
                                    color: Colors.white,
                                  )
                                : SvgPicture.asset(
                                    'assets/icons/Circle.svg',
                                    color: Colors.white,
                                  ),
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
