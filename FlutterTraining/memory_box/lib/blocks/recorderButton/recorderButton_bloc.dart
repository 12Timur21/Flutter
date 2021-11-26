import 'package:bloc/bloc.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton._event.dart';
import 'package:memory_box/blocks/recorderButton/recorderButton_state.dart';

class RecorderButtomBloc extends Bloc<Button, RecorderButtonState> {
  RecorderButtomBloc(RecorderButtonState initialState) : super(initialState);

  @override
  Stream<RecorderButtonState> mapEventToState(Button event) async* {
    if (event is ChangeIcon) {
      yield RecorderButtonState(
        selectedIcon: event.selectedIcon,
      );
    }
  }
}
