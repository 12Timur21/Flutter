import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_bloc.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_state.dart';
import 'package:memory_box/blocks/bottom_navigation_index_control/bottom_navigation_index_control_cubit.dart';
import 'package:memory_box/routes/app_router.dart';
import 'package:memory_box/screens/home_screen/home_screen.dart';
import 'package:memory_box/screens/recording_screen/recording_barrel.dart';

import 'package:memory_box/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:memory_box/widgets/drawer/custom_drawer.dart';

class MainPage extends StatefulWidget {
  static const routeName = 'MainPage';

  const MainPage({Key? key}) : super(key: key);
  static final GlobalKey<NavigatorState> navigationKey =
      GlobalKey<NavigatorState>();
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isOpenBottomSheet = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // NavigationService.instance.initKey(_navigationKey);
    super.initState();
  }

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
                    return const RecordingScreen();
                  }
                  if (state is ListeningPageState) {
                    // return Container();
                    return const ListeningScreen();
                  }
                  if (state is PreviewPageState) {
                    return const RecordingPreviewScreen();
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
              BlocProvider.of<BottomNavigationIndexControlCubit>(context)
                  .changeIcon(
                RecorderButtonStates.withIcon,
              );
              isOpenBottomSheet = false;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: Navigator(
        key: MainPage.navigationKey,
        initialRoute: HomeScreen.routeName,
        onGenerateRoute: AppRouter.generateRoute,
      ),
      bottomNavigationBar: BottomNavBar(
        // navigationKey: _navigationKey,
        openButtomSheet: _showBottomSheet,
      ),
    );
  }
}
