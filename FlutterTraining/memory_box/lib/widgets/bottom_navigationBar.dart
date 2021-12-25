import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/mainPageNavigation/navigation_bloc.dart';
import 'package:memory_box/blocks/mainPageNavigation/navigation_event.dart';
import 'package:memory_box/blocks/mainPageNavigation/navigation_state.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton._event.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_bloc.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_state.dart';
import 'package:memory_box/widgets/RecorderButtons/default_recorder_button.dart';
import 'package:memory_box/widgets/RecorderButtons/recorder_button_withIcon.dart';
import 'package:memory_box/widgets/RecorderButtons/recorder_button_withLine.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({required this.openButtomSheet, Key? key})
      : super(key: key);
  final Function openButtomSheet;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  Widget recorderIcon = const RecorderButtonWithIcon();

  TextStyle bottomNavigationBarTextStyle = const TextStyle(
    fontFamily: 'TTNorms',
    fontWeight: FontWeight.w400,
    fontSize: 11,
  );

  void _onBottomNavigatorTapped(int index) {
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);
    NavigationPages? navigationPage;

    if (index == 0) navigationPage = NavigationPages.HomePage;
    if (index == 1) navigationPage = NavigationPages.CollectionsListPage;
    if (index == 2) {
      widget.openButtomSheet();
      return;
    }
    if (index == 3) navigationPage = NavigationPages.AudioListPage;
    if (index == 4) navigationPage = NavigationPages.ProfilePage;

    setState(() {
      _selectedIndex = index;
    });

    navigationBloc.add(
      NavigateTo(navigationPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(140, 132, 226, 1),
        onTap: _onBottomNavigatorTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Home.svg',
              color: _selectedIndex == 0
                  ? const Color.fromRGBO(140, 132, 226, 1)
                  : null,
            ),
            title: Text(
              'Главная',
              style: bottomNavigationBarTextStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Category.svg',
              color: _selectedIndex == 1
                  ? const Color.fromRGBO(140, 132, 226, 1)
                  : null,
            ),
            title: Text(
              'Подборки',
              style: bottomNavigationBarTextStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: BlocBuilder<RecorderButtomBloc, RecorderButtonState>(
              builder: (BuildContext context, RecorderButtonState state) {
                if (state.selectedIcon == RecorderButtonStates.WithIcon) {
                  return RecorderButtonWithIcon();
                }
                if (state.selectedIcon == RecorderButtonStates.WithLine) {
                  return RecorderButtonWithLine();
                }
                if (state.selectedIcon == RecorderButtonStates.Default) {
                  return DefaultRecorderButton();
                }
                return Container();
              },
            ),
            title: Text(
              'Запись',
              style: TextStyle(
                color: Color.fromRGBO(241, 180, 136, 1),
              ).merge(bottomNavigationBarTextStyle),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Paper.svg',
              color: _selectedIndex == 3
                  ? const Color.fromRGBO(140, 132, 226, 1)
                  : null,
            ),
            title: Text(
              'Аудиозаписи',
              style: bottomNavigationBarTextStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Profile.svg',
              color: _selectedIndex == 4
                  ? const Color.fromRGBO(140, 132, 226, 1)
                  : null,
            ),
            title: Text(
              'Профиль',
              style: bottomNavigationBarTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
