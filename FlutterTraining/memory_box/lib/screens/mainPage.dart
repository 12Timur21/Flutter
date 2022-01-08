import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_bloc.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_state.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton._event.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_bloc.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_state.dart';
import 'package:memory_box/routes/app_router.dart';
import 'package:memory_box/screens/home_screen/home_screen.dart';
import 'package:memory_box/screens/recording_screen/recording_screen.dart';
import 'package:memory_box/utils/navigationService.dart';
import 'package:memory_box/widgets/bottom_navigationBar/bottom_navigationBar.dart';
import 'package:memory_box/widgets/drawer/custom_drawer.dart';

class MainPage extends StatefulWidget {
  static const routeName = 'MainPage';

  const MainPage({Key? key}) : super(key: key);

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    NavigationService.instance.initKey(_navigationKey);
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
                    return const RecordingPage();
                  }
                  if (state is ListeningPageState) {
                    return const ListeningPage();
                  }
                  if (state is PreviewPageState) {
                    return const RecordPreview();
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
      const ChangeIcon(
        RecorderButtonStates.withIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: Navigator(
        key: _navigationKey,
        initialRoute: HomeScreen.routeName,
        onGenerateRoute: AppRouter.generateRoute,
      ),
      bottomNavigationBar: BottomNavBar(
        openButtomSheet: _showBottomSheet,
      ),
    );
  }
}
