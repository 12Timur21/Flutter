import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_bloc.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_state.dart';
import 'package:memory_box/blocks/mainPageNavigation/navigation_bloc.dart';
import 'package:memory_box/blocks/mainPageNavigation/navigation_state.dart';
import 'package:memory_box/blocks/playListNavigation/playListNavigation_bloc.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton._event.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_bloc.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_state.dart';
import 'package:memory_box/screens/audio_list.dart';
import 'package:memory_box/screens/playList/createPlayListPage.dart';
import 'package:memory_box/screens/playList/playListPage.dart';
import 'package:memory_box/screens/playList/selectSoundPlayList.dart';
import 'package:memory_box/screens/profile.dart';
import 'package:memory_box/screens/recording/record_preview.dart';

import 'package:memory_box/screens/subscription.dart';
import 'package:memory_box/screens/test.dart';
import 'package:memory_box/widgets/bottom_navigationBar.dart';
import 'package:memory_box/widgets/custom_navigationBar.dart';

import 'recording/listening_tale.dart';
import 'recording/recording_page.dart';

class MainPage extends StatefulWidget {
  static const routeName = 'MainPage';

  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextStyle bottomNavigationBarTextStyle = const TextStyle(
    fontFamily: 'TTNorms',
    fontWeight: FontWeight.w400,
    fontSize: 11,
  );

  bool isOpenBottomSheet = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showBottomSheet() {
    isOpenBottomSheet = true;
    _scaffoldKey.currentState
        ?.showBottomSheet(
          (BuildContext context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<BottomSheetBloc>(
                  create: (context) => BottomSheetBloc(
                    ListeningPageState(),
                  ),
                ),
                BlocProvider(
                  create: (context) => AudioplayerBloc(),
                ),
              ],
              // child: GestureDetector(
              // onVerticalDragDown: (_) {},
              child: BlocBuilder<BottomSheetBloc, BottomSheetState>(
                builder: (BuildContext context, BottomSheetState state) {
                  if (state is RecorderPageState) {
                    return const RecordingPage();
                  }
                  if (state is ListeningPageState) {
                    return const ListeningPage();
                  }
                  if (state is PreviewPageState) {
                    return RecordPreview();
                  }
                  return Container();
                },
              ),
              // ),
            );
          },
          // transitionAnimationController: transition,
          backgroundColor: Colors.transparent,
        )
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              changeRecoringButtonToDefault();
              isOpenBottomSheet = false;
            });
          }
        });
  }

  void changeRecoringButtonToDefault() {
    final recorderButtomBloc = BlocProvider.of<RecorderButtomBloc>(context);
    recorderButtomBloc.add(
      ChangeIcon(
        RecorderButtonStates.WithIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: const CustomNavigationBar(),
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          if (state.selectedItem == NavigationPages.HomePage) {
            return const Test();
          }
          if (state.selectedItem == NavigationPages.CollectionsListPage) {
            return BlocBuilder<PlayListNavigationBloc, PlayListNavigationState>(
              builder: (context, state) {
                if (state is PlayListCreationScreen) {
                  return CreatePlayListPage(
                    collectionCreationState: state.playListCreationState,
                  );
                }
                if (state is PlayListSelectionScreen) {
                  return SelectSoundPlayList(
                    collectionCreationState: state.playListCreationState,
                  );
                }
                return const PlayListPage();
              },
            );
          }
          if (state.selectedItem == NavigationPages.AudioListPage) {
            return const AudioListPage();
          }
          if (state.selectedItem == NavigationPages.ProfilePage) {
            return ProfilePage();
          }
          if (state.selectedItem == NavigationPages.SubscriptionPage) {
            return SubscriptionPage();
          }

          return Container();
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavBar(
            openButtomSheet: _showBottomSheet,
          ),
        ),
      ),
    );
  }
}
