import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/mainPageNavigation/navigation_bloc.dart';
import 'package:memory_box/blocks/mainPageNavigation/navigation_event.dart';
import 'package:memory_box/blocks/mainPageNavigation/navigation_state.dart';
import 'package:memory_box/screens/audio_list.dart';
import 'package:memory_box/screens/mainPage.dart';
import 'package:memory_box/screens/subscription.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

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
                Navigator.of(context).pop();
              },
            ),
            CustomListTyle(
              title: 'Профиль',
              svgUrl: 'assets/icons/Profile.svg',
              callback: () {
                navigationBloc.add(
                  NavigateTo(NavigationPages.ProfilePage),
                );
              },
            ),
            CustomListTyle(
              title: 'Подборки',
              svgUrl: 'assets/icons/Category.svg',
              callback: () {
                navigationBloc.add(
                  NavigateTo(NavigationPages.CollectionsListPage),
                );
              },
            ),
            CustomListTyle(
              title: 'Все аудиофайлы',
              svgUrl: 'assets/icons/Paper.svg',
              callback: () {
                navigationBloc.add(
                  NavigateTo(NavigationPages.AudioListPage),
                );
              },
            ),
            CustomListTyle(
              title: 'Поиск',
              svgUrl: 'assets/icons/Search.svg',
              callback: () {},
            ),
            CustomListTyle(
              title: 'Недавно удаленные',
              svgUrl: 'assets/icons/Delete.svg',
              callback: () {},
            ),
            const SizedBox(
              height: 30,
            ),
            CustomListTyle(
              title: 'Подписка',
              svgUrl: 'assets/icons/Wallet.svg',
              callback: () {
                navigationBloc.add(
                  NavigateTo(NavigationPages.SubscriptionPage),
                );
                // Navigator.pushNamed(
                //   context,
                //   MainPage.routeName,
                // );
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
