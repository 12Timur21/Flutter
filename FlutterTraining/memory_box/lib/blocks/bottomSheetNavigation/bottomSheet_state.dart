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
  ListeningPageState(
    bottomSheetItem,
    this.recorderTime,
  ) : super(bottomSheetItem);

  final Duration recorderTime;
}

enum BottomSheetItems {
  RecordingPage,
  ListeningPage,
}
