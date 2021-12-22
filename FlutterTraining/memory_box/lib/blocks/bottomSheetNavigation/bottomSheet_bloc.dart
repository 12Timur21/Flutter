import 'package:bloc/bloc.dart';
import 'bottomSheet_event.dart';
import 'bottomSheet_state.dart';

class BottomSheetBloc extends Bloc<BottomSheet, BottomSheetState> {
  BottomSheetBloc(BottomSheetState initialState) : super(RecorderPageState());

  @override
  Stream<BottomSheetState> mapEventToState(BottomSheet event) async* {
    if (event is OpenRecoderPage) {
      yield RecorderPageState();
    }
    if (event is OpenListeningPage) {
      yield ListeningPageState();
    }
    if (event is OpenPreviewPage) {
      yield PreviewPageState();
    }
  }
}
