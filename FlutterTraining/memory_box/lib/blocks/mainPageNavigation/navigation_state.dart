import 'package:flutter/material.dart';
import 'package:memory_box/screens/audio_list.dart';
import 'package:memory_box/screens/home.dart';
import 'package:memory_box/screens/profile.dart';

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
  SubscriptionPage,
  SelectionsPage,
}
