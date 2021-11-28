import 'package:bloc/bloc.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_state.dart';
import 'bottomSheet_event.dart';
import 'bottomSheet_state.dart';

class BottomSheetBloc extends Bloc<BottomSheet, BottomSheetState> {
  BottomSheetBloc(BottomSheetState initialState) : super(initialState);

  @override
  Stream<BottomSheetState> mapEventToState(BottomSheet event) async* {
    if (event is OpenRecoderPage) {
      if (event.bottomSheetItem != state.bottomSheetItem) {
        yield RecorderPageState(event.bottomSheetItem);
      }
    }
    if (event is OpenListeningPage) {
      if (event.bottomSheetItem != state.bottomSheetItem) {
        yield ListeningPageState(
          event.bottomSheetItem,
          event.recorderTime,
        );
      }
    }
  }
}
