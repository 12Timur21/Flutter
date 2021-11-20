import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/mainPageNavigation/navigation_bloc.dart';
import 'package:memory_box/blocks/mainPageNavigation/navigation_event.dart';
import 'package:memory_box/screens/audioListPage.dart';
import 'package:memory_box/screens/homePage.dart';
import 'package:memory_box/screens/profilePage.dart';
import 'package:memory_box/screens/recordingPage.dart';
import 'package:memory_box/screens/selectionsPage.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({required this.secondKey, Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> secondKey;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  bool isOpenBottomSheet = false;

  TextStyle bottomNavigationBarTextStyle = const TextStyle(
    fontFamily: 'TTNorms',
    fontWeight: FontWeight.w400,
    fontSize: 11,
  );

  void _showBottomSheet() {
    //!
    isOpenBottomSheet = true;
    widget.secondKey.currentState
        ?.showBottomSheet(
          (BuildContext context) {
            return RecordingPage();
          },
          backgroundColor: Colors.transparent,
        )
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              isOpenBottomSheet = false;
            });
            print('mounted');
          }
        });
  }

  String convertIndexToRouteName(int index) {
    switch (index) {
      case 0:
        return HomePage.routeName;
      case 1:
        return SelectionsPage.routeName;
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
      // if (index != 2)
      //! БАГ сл сменой цветов
      setState(
        () {
          _selectedIndex = index;
        },
      );

      if (index == 2) {
        if (!isOpenBottomSheet) _showBottomSheet();
      } else {
        counterBloc.add(
          NavigateTo(
            convertIndexToRouteName(index),
          ),
        );
      }
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
            icon: Stack(
              alignment: Alignment.topCenter,
              children: [
                if (isOpenBottomSheet)
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(241, 180, 136, 1),
                          offset: Offset(0, -10),
                        ),
                      ],
                    ),
                    width: 5,
                    height: 30,
                  ),
                Container(
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
                      child: isOpenBottomSheet == false
                          ? SvgPicture.asset(
                              'assets/icons/Voice.svg',
                              height: 28,
                            )
                          : null,
                    ),
                  ),
                ),
              ],
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
