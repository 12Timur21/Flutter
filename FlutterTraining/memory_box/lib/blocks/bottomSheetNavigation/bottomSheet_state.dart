class BottomSheetState {
  BottomSheetState(this.bottomSheetItem);
  BottomSheetItems bottomSheetItem;
}

class RecorderPageState extends BottomSheetState {
  RecorderPageState(
    bottomSheetItem,
  ) : super(bottomSheetItem);
}

class ListeningPageState extends BottomSheetState {
  ListeningPageState(bottomSheetItem) : super(bottomSheetItem);
}

enum BottomSheetItems {
  RecordingPage,
  ListeningPage,
  PreviewRecord,
}
