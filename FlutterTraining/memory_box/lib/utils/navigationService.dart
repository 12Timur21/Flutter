import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  NavigationService._();
  static NavigationService instance = NavigationService._();

  String? _newRouteName;
  Object? _newArguments;
  String? _oldRouteName;
  Object? _oldArguments;

  void updateHistory(String z, Object? x) {
    _oldRouteName = _newRouteName;
    _newRouteName = z;

    _oldArguments = _newArguments;
    _newArguments = x;
  }

  void initKey(GlobalKey<NavigatorState> key) {
    navigationKey = key;
  }

  void navigateTo(
    String routeName, {
    Object? arguments,
    bool saveNewRoute = true,
  }) {
    if (saveNewRoute) {
      updateHistory(routeName, arguments);
    }

    navigationKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  void navigateToPreviousPage() {
    updateHistory(_oldRouteName ?? '', _oldArguments);

    if (_oldRouteName != null) {
      navigationKey.currentState?.pushNamed(
        _newRouteName!,
        arguments: _newArguments,
      );
    }
  }
}
