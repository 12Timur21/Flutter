import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/mainPageNavigation/navigation_bloc.dart';
import 'package:memory_box/blocks/mainPageNavigation/navigation_event.dart';
import 'package:memory_box/screens/audioListPage.dart';
import 'package:memory_box/screens/homePage.dart';
import 'package:memory_box/screens/mainPage.dart';
import 'package:memory_box/screens/profilePage.dart';
import 'package:memory_box/screens/recordingPage.dart';
import 'package:memory_box/screens/selectionsPage.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  TextStyle bottomNavigationBarTextStyle = const TextStyle(
    fontFamily: 'TTNorms',
    fontWeight: FontWeight.w400,
    fontSize: 11,
  );

  String convertIndexToRouteName(int index) {
    switch (index) {
      case 0:
        return HomePage.routeName;
      case 1:
        return SelectionsPage.routeName;
      case 2:
        return RecordingPage.routeName;
      case 3:
        return AudioListPage.routeName;
      case 4:
        return ProfilePage.routeName;
      default:
        throw Exception("Can't convert index to routeName");
    }
  }

  @override
  Widget build(BuildContext context) {
    final counterBloc = BlocProvider.of<NavigationBloc>(context);
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
      counterBloc.add(
        NavigateTo(
          convertIndexToRouteName(index),
        ),
      );
    }

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
        child: BottomNavigationBar(
          backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromRGBO(140, 132, 226, 1),
          onTap: _onItemTapped,
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
              icon: Container(
                height: 46,
                width: 46,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(241, 180, 136, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 3),
                    child: SvgPicture.asset(
                      'assets/icons/Voice.svg',
                      height: 28,
                    ),
                  ),
                ),
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
      ),
    );
  }
}
