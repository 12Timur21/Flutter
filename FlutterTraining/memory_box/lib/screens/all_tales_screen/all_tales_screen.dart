import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/blocks/list_builder/list_builder_bloc.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/resources/app_coloros.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/utils/formatting.dart';
import 'package:memory_box/widgets/appBar_withButtons.dart';
import 'package:memory_box/widgets/audioplayer/audio_player.dart';
import 'package:memory_box/widgets/tale_list_tiles/tale_list_tile_with_popup_menu.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:share_plus/share_plus.dart';

class AllTalesScreen extends StatefulWidget {
  static const routeName = 'AllTalesScreen';
  const AllTalesScreen({Key? key}) : super(key: key);

  @override
  _AllTalesScreenState createState() => _AllTalesScreenState();
}

class _AllTalesScreenState extends State<AllTalesScreen> {
  bool _isRepitMode = false;
  int _durationSumInMS = 0;

  @override
  void dispose() {
    BlocProvider.of<AudioplayerBloc>(context).add(
      DisposePlayer(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ListBuilderBloc()
            ..add(
              InitializeListBuilderWithFutureRequest(
                DatabaseService.instance.getAllNotDeletedTaleModels(),
              ),
            ),
        ),
        BlocProvider(
          create: (context) => AudioplayerBloc()
            ..add(
              InitPlayer(),
            ),
        ),
      ],
      child: BackgroundPattern(
        patternColor: AppColors.lightBlue,
        isShort: true,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBarWithButtons(
            leadingOnPress: () {
              Scaffold.of(context).openDrawer();
            },
            title: Container(
              margin: const EdgeInsets.only(top: 10),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Аудиозаписи',
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
            actionsOnPress: () {},
          ),
          body: BlocConsumer<ListBuilderBloc, ListBuilderState>(
            listener: (context, listBuilderState) {
              if (listBuilderState is PlayTaleState) {
                final int index = listBuilderState.currentPlayTaleIndex!;
                context.read<AudioplayerBloc>().add(
                      Play(
                        taleModel: listBuilderState.allTales![index],
                        isAutoPlay: true,
                      ),
                    );
              }

              if (listBuilderState is StopTaleState) {
                context.read<AudioplayerBloc>().add(
                      Pause(),
                    );
              }
            },
            builder: (context, listBuilderState) {
              _durationSumInMS = 0;
              listBuilderState.allTales?.forEach((TaleModel taleModel) {
                _durationSumInMS += taleModel.duration?.inMilliseconds ?? 0;
              });

              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${listBuilderState.allTales?.length ?? 0} аудио',
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${convertDurationToString(
                                    duration: Duration(
                                      milliseconds: _durationSumInMS,
                                    ),
                                    formattingType:
                                        TimeFormattingType.hourMinute,
                                  )} часов',
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isRepitMode = !_isRepitMode;
                                });
                                if (_isRepitMode) {
                                  context.read<ListBuilderBloc>().add(
                                        PlayAllTales(true),
                                      );
                                } else {
                                  context.read<ListBuilderBloc>().add(
                                        PlayAllTales(false),
                                      );
                                }
                              },
                              child: Container(
                                  width: 222,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.wildSand.withOpacity(
                                      _isRepitMode == false ? 0.5 : 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 168,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: AppColors.wildSand,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppIcons.play,
                                              width: 50,
                                            ),
                                            const Text('Запустить все'),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                          left: 8,
                                        ),
                                        child: SvgPicture.asset(
                                          AppIcons.repeat,
                                          color: AppColors.wildSand.withOpacity(
                                            _isRepitMode == false ? 0.5 : 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Expanded(
                          child: listBuilderState.isInit
                              ? ListView.builder(
                                  itemCount:
                                      listBuilderState.allTales?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    TaleModel taleModel =
                                        listBuilderState.allTales![index];
                                    bool isPlay = false;

                                    if (listBuilderState.currentPlayTaleIndex ==
                                            index &&
                                        listBuilderState.isPlay) {
                                      isPlay = true;
                                    }

                                    return TaleListTileWithPopupMenu(
                                      key: UniqueKey(),
                                      isPlayMode: isPlay,
                                      taleModel: taleModel,
                                      onAddToPlaylist: () {},
                                      onDelete: () {
                                        context.read<ListBuilderBloc>().add(
                                              DeleteTale(index),
                                            );
                                      },
                                      onPause: () {
                                        context.read<ListBuilderBloc>().add(
                                              PlayTale(index),
                                            );
                                      },
                                      onPlay: () {
                                        context.read<ListBuilderBloc>().add(
                                              StopTale(),
                                            );
                                      },
                                      onRename: (String newTitle) {
                                        context.read<ListBuilderBloc>().add(
                                              RenameTale(
                                                taleModel.ID!,
                                                newTitle,
                                              ),
                                            );
                                      },
                                      onShare: () {
                                        Share.share(taleModel.url!);
                                      },
                                      onUndoRenaming: () {
                                        context.read<ListBuilderBloc>().add(
                                              UndoRenameTale(),
                                            );
                                      },
                                    );
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                      ],
                    ),
                  ),
                  BlocConsumer<AudioplayerBloc, AudioplayerState>(
                    listener: (context, audioPlayerState) {
                      if (audioPlayerState.isTaleEnd) {
                        if (!listBuilderState.isPlayAllTalesMode) {
                          context.read<AudioplayerBloc>().add(
                                AnnulAudioPlayer(),
                              );
                        }
                        context.read<ListBuilderBloc>().add(
                              TaleEndPlay(),
                            );
                      }
                    },
                    builder: (context, audioPlayerState) {
                      if (listBuilderState.currentPlayTaleIndex == null) {
                        return Container();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AudioPlayer(
                            taleModel: audioPlayerState.taleModel,
                            currentPlayDuration:
                                audioPlayerState.currentPlayDuration,
                            isPlay: listBuilderState.isPlay,
                            next: () {
                              context.read<ListBuilderBloc>().add(NextTale());
                            },
                            pause: () {
                              context.read<ListBuilderBloc>().add(
                                    StopTale(),
                                  );
                            },
                            play: () {
                              context.read<ListBuilderBloc>().add(
                                    PlayTale(
                                      listBuilderState.currentPlayTaleIndex!,
                                    ),
                                  );
                            },
                            seek: (double durationInMs) {
                              context.read<AudioplayerBloc>().add(
                                    Seek(
                                      currentPlayTimeInSec: durationInMs,
                                    ),
                                  );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
