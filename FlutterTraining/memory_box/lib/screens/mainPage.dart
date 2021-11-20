import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/mainPageNavigation/navigation_bloc.dart';
import 'package:memory_box/blocks/mainPageNavigation/navigation_state.dart';
import 'package:memory_box/screens/homePage.dart';
import 'package:memory_box/widgets/bottomNavigationBar.dart';
import 'package:memory_box/widgets/navigationMenu.dart';

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

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavigationBloc>(
      create: (BuildContext context) => NavigationBloc(
        const NavigationState(
          selectedItem: HomePage(),
        ),
      ),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (BuildContext context, NavigationState state) => Scaffold(
          key: _scaffoldKey,
          drawer: const NavigationBar(),
          body: state.selectedItem,
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
                secondKey: _scaffoldKey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
