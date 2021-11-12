import 'package:flutter/material.dart';
import 'package:memory_box/screens/audioListPage.dart';
import 'package:memory_box/screens/homePage.dart';
import 'package:memory_box/screens/profilePage.dart';
import 'package:memory_box/screens/recordingPage.dart';
import 'package:memory_box/screens/selectionsPage.dart';

class NavigationState {
  final Widget? selectedItem;
  const NavigationState({required this.selectedItem});
}

// сторінки навігації можна замінити на сторінки, які підтримуються вашим застосунком
Map<String, Widget> NavigationItem = {
  HomePage.routeName: HomePage(),
  SelectionsPage.routeName: SelectionsPage(),
  RecordingPage.routeName: RecordingPage(),
  AudioListPage.routeName: AudioListPage(),
  ProfilePage.routeName: ProfilePage(),
};
