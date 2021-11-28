import 'bottomSheet_state.dart';

abstract class BottomSheet {
  BottomSheet(this.bottomSheetItem);
  final BottomSheetItems bottomSheetItem;
}

class OpenRecoderPage extends BottomSheet {
  OpenRecoderPage(bottomSheetItem) : super(bottomSheetItem);
}

class OpenListeningPage extends BottomSheet {
  OpenListeningPage(bottomSheetItem) : super(bottomSheetItem);
}
