import 'package:flutter/material.dart';
import 'package:memory_box/screens/Recording/listeningPage.dart';
import 'package:memory_box/screens/Recording/recordingPage.dart';

class BottomSheetState {
  final BottomSheetItems bottomSheetItem;
  const BottomSheetState({required this.bottomSheetItem});
}

enum BottomSheetItems {
  RecordingPage,
  ListeningPage,
}
