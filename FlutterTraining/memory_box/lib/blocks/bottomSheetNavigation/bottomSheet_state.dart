class BottomSheetState {}

class RecorderPageState extends BottomSheetState {}

class ListeningPageState extends BottomSheetState {}

class PreviewPageState extends BottomSheetState {
  final String soundTitle;
  PreviewPageState(this.soundTitle);
}
