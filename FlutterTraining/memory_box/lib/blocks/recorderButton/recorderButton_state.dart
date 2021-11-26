import 'package:flutter/material.dart';
import 'package:memory_box/screens/Recording/listeningPage.dart';
import 'package:memory_box/screens/Recording/recordingPage.dart';

class RecorderButtonState {
  final RecorderButtonStates selectedIcon;
  const RecorderButtonState({required this.selectedIcon});
}

enum RecorderButtonStates {
  Default,
  WithIcon,
  WithLine,
}
