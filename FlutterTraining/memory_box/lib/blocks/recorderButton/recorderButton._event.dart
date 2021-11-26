import 'recorderButton_state.dart';

abstract class Button {
  const Button();
}

class ChangeIcon extends Button {
  const ChangeIcon(this.selectedIcon);

  final RecorderButtonStates selectedIcon;
}
