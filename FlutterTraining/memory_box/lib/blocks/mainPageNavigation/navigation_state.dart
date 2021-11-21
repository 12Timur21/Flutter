import 'package:flutter/material.dart';
import 'package:memory_box/screens/audioListPage.dart';
import 'package:memory_box/screens/homePage.dart';
import 'package:memory_box/screens/profilePage.dart';
import 'package:memory_box/screens/selectionsPage.dart';

class NavigationState {
  final Widget? selectedItem;
  const NavigationState({required this.selectedItem});
}

Map<String, Widget> NavigationItem = {
  HomePage.routeName: HomePage(),
  SelectionsPage.routeName: SelectionsPage(),
  AudioListPage.routeName: AudioListPage(),
  ProfilePage.routeName: ProfilePage(),
};
