import 'package:flutter/material.dart';

class RecorderButtonState {
  final RecorderButtonStates selectedIcon;
  const RecorderButtonState({required this.selectedIcon});
}

enum RecorderButtonStates {
  Default,
  WithIcon,
  WithLine,
}
