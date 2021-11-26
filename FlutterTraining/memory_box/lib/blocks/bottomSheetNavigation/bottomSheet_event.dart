import 'bottomSheet_state.dart';

abstract class BottomSheet {
  const BottomSheet();
}

class OpenPage extends BottomSheet {
  const OpenPage(this.bottomSheetItem);

  final BottomSheetItems bottomSheetItem;
}
