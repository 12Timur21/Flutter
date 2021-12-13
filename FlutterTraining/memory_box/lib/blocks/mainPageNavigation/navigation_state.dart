import 'package:flutter/material.dart';
import 'package:memory_box/screens/audioListPage.dart';
import 'package:memory_box/screens/homePage.dart';
import 'package:memory_box/screens/profilePage.dart';
import 'package:memory_box/screens/selectionsPage.dart';

class NavigationState {
  final NavigationPages? selectedItem;
  const NavigationState({required this.selectedItem});
}

enum NavigationPages {
  HomePage,
  CollectionsListPage,
  RecordingPage,
  AudioListPage,
  ProfilePage,
  SubscriptionPage
}
