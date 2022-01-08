import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  NavigationService._();
  static NavigationService instance = NavigationService._();

  void initKey(GlobalKey<NavigatorState> key) {
    navigationKey = key;
  }

  void navigateTo(String routeName, [Object? arguments]) {
    navigationKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  // Future<dynamic> navigateToRoute(MaterialPageRoute _rn) {
  //   return navigationKey.currentState.push(_rn);
  // }

  void goback() {
    navigationKey.currentState?.pop();
  }
}
