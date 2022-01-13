import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/playListNavigation/playListNavigation_bloc.dart';
import 'package:memory_box/screens/all_tales_screen/all_tales_screen.dart';
import 'package:memory_box/screens/deleted_tales_screen/deleted_tales_screen.dart';
import 'package:memory_box/screens/home_screen/home_screen.dart';
import 'package:memory_box/screens/mainPage.dart';
import 'package:memory_box/screens/playlist_screen/playlist_screen.dart';
import 'package:memory_box/screens/profile_screen/profile_screen.dart';
import 'package:memory_box/screens/search_tales_screen/search_tales_screen.dart';
import 'package:memory_box/screens/subscription_screen/subscription_screen.dart';
import 'package:memory_box/utils/navigationService.dart';
import 'package:memory_box/widgets/search.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListTile CustomListTyle({title, svgUrl, callback}) {
      return ListTile(
        minLeadingWidth: 0,
        visualDensity: const VisualDensity(
          horizontal: -2,
          vertical: -3,
        ),
        leading: SvgPicture.asset(
          svgUrl,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'TTNorms',
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        onTap: callback,
      );
    }

    return Container(
      color: Colors.red,
      child: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          children: <Widget>[
            DrawerHeader(
              margin: const EdgeInsets.only(
                bottom: 25,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'Аудиосказки',
                    style: TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      letterSpacing: 0.4,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Меню',
                    style: TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: Color.fromRGBO(58, 58, 85, 0.5),
                    ),
                  ),
                ],
              ),
            ),
            CustomListTyle(
              title: 'Главная',
              svgUrl: 'assets/icons/Home.svg',
              callback: () {
                MainPage.navigationKey.currentState?.pushNamed(
                  HomeScreen.routeName,
                );
              },
            ),
            CustomListTyle(
              title: 'Профиль',
              svgUrl: 'assets/icons/Profile.svg',
              callback: () {
                MainPage.navigationKey.currentState?.pushNamed(
                  ProfileScreen.routeName,
                );
              },
            ),
            CustomListTyle(
              title: 'Подборки',
              svgUrl: 'assets/icons/Category.svg',
              callback: () {
                MainPage.navigationKey.currentState?.pushNamed(
                  PlaylistScreen.routeName,
                );
              },
            ),
            CustomListTyle(
              title: 'Все аудиофайлы',
              svgUrl: 'assets/icons/Paper.svg',
              callback: () {
                MainPage.navigationKey.currentState?.pushNamed(
                  AllTalesScreen.routeName,
                );
              },
            ),
            CustomListTyle(
              title: 'Поиск',
              svgUrl: 'assets/icons/Search.svg',
              callback: () {
                MainPage.navigationKey.currentState?.pushNamed(
                  SearchTalesScreen.routeName,
                );
              },
            ),
            CustomListTyle(
              title: 'Недавно удаленные',
              svgUrl: 'assets/icons/Delete.svg',
              callback: () {
                MainPage.navigationKey.currentState?.pushNamed(
                  DeletedTalesScreen.routeName,
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            CustomListTyle(
              title: 'Подписка',
              svgUrl: 'assets/icons/Wallet.svg',
              callback: () {
                MainPage.navigationKey.currentState?.pushNamed(
                  SubscriptionScreen.routeName,
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            CustomListTyle(
              title: 'Написать в поддержку',
              svgUrl: 'assets/icons/Edit.svg',
              callback: () {},
            ),
          ],
        ),
      ),
    );
  }
}
