import 'package:bloc/bloc.dart';
import 'bottomSheet_event.dart';
import 'bottomSheet_state.dart';

class BottomSheetBloc extends Bloc<BottomSheet, BottomSheetState> {
  BottomSheetBloc(BottomSheetState initialState) : super(initialState);

  @override
  Stream<BottomSheetState> mapEventToState(BottomSheet event) async* {
    if (event is OpenPage) {
      if (event != state.bottomSheetItem) {
        yield BottomSheetState(
          bottomSheetItem: event.bottomSheetItem,
        );
      }
    }
  }
}
