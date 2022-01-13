import 'package:bloc/bloc.dart';

part 'bottom_navigation_index_control_state.dart';

class BottomNavigationIndexControlCubit
    extends Cubit<BottomNavigationIndexControlState> {
  BottomNavigationIndexControlCubit()
      : super(BottomNavigationIndexControlState(0));

  void changeIndex(int index) {
    emit(
      BottomNavigationIndexControlState(index),
    );
  }

  void changeIcon(RecorderButtonStates recorderButtonState) {
    emit(
      BottomNavigationIndexControlState(
        3,
        recorderButtonState: recorderButtonState,
      ),
    );
  }
}
