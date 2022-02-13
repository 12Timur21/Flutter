import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/resources/app_coloros.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/screens/all_tales_screen/all_tales_screen.dart';
import 'package:memory_box/screens/mainPage.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BackgroundPattern(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          primary: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.only(left: 6),
            child: IconButton(
              icon: SvgPicture.asset(
                AppIcons.burger,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Подборки',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'TTNorms',
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      MainPage.navigationKey.currentState
                          ?.pushNamed(AllTalesScreen.routeName);
                    },
                    child: const Text(
                      'Открыть все',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'TTNorms',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: SizedBox(
                height: 240,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.seaNymph.withOpacity(0.9),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Здесь будет твой набор сказок',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'TTNorms',
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Добавить',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'TTNorms',
                                  fontWeight: FontWeight.normal,
                                  shadows: [
                                    Shadow(
                                      color: Colors.white,
                                      offset: Offset(0, -5),
                                    )
                                  ],
                                  color: Colors.transparent,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.tacao.withOpacity(0.9),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Тут',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                top: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.danube.withOpacity(0.9),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Тут',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                child: CustomScrollView(
                  slivers: [
                    // Container(
                    //   height: 10,
                    //   color: Colors.black,
                    // ),
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      // backgroundColor: Colors.amber,
                      // shadowColor: Colors.black,
                      // elevation: 2,
                      shape: const ContinuousRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      backgroundColor: AppColors.wildSand,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Аудиозаписи',
                            style: TextStyle(
                              color: Colors.black,
                              // fontFamily: 'TTNorms',
                              fontSize: 24,
                              letterSpacing: 0.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              MainPage.navigationKey.currentState
                                  ?.pushNamed(AllTalesScreen.routeName);
                            },
                            child: const Text(
                              'Открыть все',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'TTNorms',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // expandedHeight: 30,
                      // collapsedHeight: 150,
                    ),
                    // MultiBlocProvider(
                    //   providers: [
                    //     BlocProvider(
                    //       create: (context) => ListBuilderBloc()
                    //         ..add(
                    //           InitializeListBuilderWithFutureRequest(
                    //             DatabaseService.instance
                    //                 .getAllNotDeletedTaleModels(),
                    //           ),
                    //         ),
                    //     ),
                    //     BlocProvider(
                    //       create: (context) => AudioplayerBloc()
                    //         ..add(
                    //           InitPlayer(),
                    //         ),
                    //     ),
                    //   ],
                    //   child: BlocConsumer<ListBuilderBloc, ListBuilderState>(
                    //     listener: (context, listBuilderState) {
                    //       if (listBuilderState is PlayTaleState) {
                    //         final int index =
                    //             listBuilderState.currentPlayTaleIndex!;
                    //         context.read<AudioplayerBloc>().add(
                    //               Play(
                    //                 taleModel:
                    //                     listBuilderState.allTales![index],
                    //                 isAutoPlay: true,
                    //               ),
                    //             );
                    //       }

                    //       if (listBuilderState is StopTaleState) {
                    //         context.read<AudioplayerBloc>().add(
                    //               Pause(),
                    //             );
                    //       }
                    //     },
                    //     builder: (context, listBuilderState) {
                    //       return SliverList(
                    //         delegate: SliverChildBuilderDelegate(
                    //           (context, index) {
                    //             TaleModel taleModel =
                    //                 listBuilderState.allTales![index];
                    //             bool isPlay = false;

                    //             if (listBuilderState.currentPlayTaleIndex ==
                    //                     index &&
                    //                 listBuilderState.isPlay) {
                    //               isPlay = true;
                    //             }

                    //             return TaleListTileWithPopupMenu(
                    //               key: UniqueKey(),
                    //               // index: index,
                    //               isPlayMode: isPlay,
                    //               taleModel: taleModel,
                    //               onAddToPlaylist: () {},
                    //               onDelete: () {
                    //                 context.read<ListBuilderBloc>().add(
                    //                       DeleteTale(index),
                    //                     );
                    //               },
                    //               onPause: () {
                    //                 context.read<ListBuilderBloc>().add(
                    //                       PlayTale(index),
                    //                     );
                    //               },
                    //               onPlay: () {
                    //                 context.read<ListBuilderBloc>().add(
                    //                       StopTale(),
                    //                     );
                    //               },
                    //               onRename: (String newTitle) {
                    //                 print('rename');
                    //                 if (taleModel.ID != null) {
                    //                   context.read<ListBuilderBloc>().add(
                    //                         RenameTale(
                    //                           taleModel.ID!,
                    //                           newTitle,
                    //                         ),
                    //                       );
                    //                 }
                    //               },
                    //               onShare: () {
                    //                 Share.share(taleModel.url!);
                    //               },
                    //               onUndoRenaming: () {
                    //                 print('undo');
                    //                 context.read<ListBuilderBloc>().add(
                    //                       UndoRenameTale(),
                    //                     );
                    //               },
                    //             );
                    //           },
                    //           childCount: listBuilderState.allTales?.length ??
                    //               0, // 1000 list items
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
