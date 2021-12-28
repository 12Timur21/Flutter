class RecorderButtonState {
  final RecorderButtonStates selectedIcon;
  const RecorderButtonState({required this.selectedIcon});
}

enum RecorderButtonStates {
  defaultIcon,
  withIcon,
  withLine,
}
