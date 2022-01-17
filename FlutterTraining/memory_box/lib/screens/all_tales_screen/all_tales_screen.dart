import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/blocks/list_builder/list_builder_bloc.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/widgets/appBar_withButtons.dart';
import 'package:memory_box/widgets/audioplayer/audio_player.dart';
import 'package:memory_box/widgets/tale_list_tiles/tale_list_tile_with_popup_menu.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';

class AllTalesScreen extends StatefulWidget {
  static const routeName = 'AllTalesScreen';
  const AllTalesScreen({Key? key}) : super(key: key);

  @override
  _AllTalesScreenState createState() => _AllTalesScreenState();
}

class _AllTalesScreenState extends State<AllTalesScreen> {
  bool isRepitMode = false;
  int? audioLenght;
  Duration? durationList;

  @override
  void dispose() {
    BlocProvider.of<AudioplayerBloc>(context).add(
      DisposePlayer(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AudioplayerBloc()
        ..add(
          InitPlayer(),
        ),
      child: BackgroundPattern(
        patternColor: const Color.fromRGBO(94, 119, 206, 1),
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
          body: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 10,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AudioPlayer(),
                ),
              ),
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
                              '${audioLenght ?? 0} аудио',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '10:30 часов',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isRepitMode = !isRepitMode;
                            });
                          },
                          child: Container(
                              width: 222,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(
                                  246,
                                  246,
                                  246,
                                  isRepitMode == false ? 0.5 : 0.2,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 168,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          246, 246, 246, 1),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/Play.svg',
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
                                      'assets/icons/Repeat.svg',
                                      color: Color.fromRGBO(
                                        246,
                                        246,
                                        246,
                                        isRepitMode == false ? 0.5 : 1,
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
                      child: BlocProvider(
                        create: (context) => ListBuilderBloc()
                          ..add(
                            InitializeListBuilder(
                              DatabaseService.instance
                                  .getAllNotDeletedTaleModels(),
                            ),
                          ),
                        child: BlocConsumer<ListBuilderBloc, ListBuilderState>(
                          listener: (context, state) {
                            // if(state is )
                          },
                          builder: (context, state) {
                            if (state.isInit) {
                              return ListView.builder(
                                itemCount: state.allTales?.length ?? 0,
                                itemBuilder: (context, index) {
                                  TaleModel? taleModel = state.allTales?[index];
                                  if (taleModel != null) {
                                    return TaleListTileWithPopupMenu(
                                      key: UniqueKey(),
                                      taleModel: taleModel,
                                    );
                                  }
                                  return const SizedBox();
                                },
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
