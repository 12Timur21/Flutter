import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_bloc.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_state.dart';
import 'package:memory_box/screens/all_tales_screen/all_tales_screen.dart';
import 'package:memory_box/screens/home_screen/home_screen.dart';
import 'package:memory_box/screens/playlist_screen/playlist_screen.dart';
import 'package:memory_box/screens/profile_screen/profile_screen.dart';
import 'package:memory_box/utils/navigationService.dart';
import 'package:memory_box/widgets/recorder_button_icons/recorder_button_icons.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({required this.openButtomSheet, Key? key})
      : super(key: key);
  final Function openButtomSheet;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final TextStyle _bottomNavigationBarTextStyle = const TextStyle(
    fontFamily: 'TTNorms',
    fontWeight: FontWeight.w400,
    fontSize: 11,
  );

  void _onBottomNavigatorTapped(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      NavigationService.instance.navigateTo(HomeScreen.routeName);
    }
    if (index == 1) {
      NavigationService.instance.navigateTo(PlaylistScreen.routeName);
    }
    if (index == 2) {
      widget.openButtomSheet();
    }
    if (index == 3) {
      NavigationService.instance.navigateTo(AllTalesScreen.routeName);
    }
    if (index == 4) {
      NavigationService.instance.navigateTo(ProfileScreen.routeName);
    }

    setState(() {
      _selectedIndex = index;
    });
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
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: Container(
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
                  style: _bottomNavigationBarTextStyle,
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
                  style: _bottomNavigationBarTextStyle,
                ),
              ),
              BottomNavigationBarItem(
                icon: BlocBuilder<RecorderButtomBloc, RecorderButtonState>(
                  builder: (BuildContext context, RecorderButtonState state) {
                    if (state.selectedIcon == RecorderButtonStates.withIcon) {
                      return const RecorderButtonWithIcon();
                    }
                    if (state.selectedIcon == RecorderButtonStates.withLine) {
                      return const RecorderButtonWithLine();
                    }
                    return const DefaultRecorderButton();
                  },
                ),
                title: Text(
                  'Запись',
                  style: const TextStyle(
                    color: Color.fromRGBO(241, 180, 136, 1),
                  ).merge(_bottomNavigationBarTextStyle),
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
                  style: _bottomNavigationBarTextStyle,
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
                  style: _bottomNavigationBarTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
