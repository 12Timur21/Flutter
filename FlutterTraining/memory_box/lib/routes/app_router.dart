import 'package:flutter/material.dart';
import 'package:memory_box/screens/mainPage.dart';
import 'package:memory_box/screens/registration.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? arguments = settings.arguments;

    WidgetBuilder builder;

    switch (settings.name) {
      case Registration.routeName:
        // final AudioPageArguments args = arguments as AudioPageArguments;
        builder = (_) => Registration(
            // id: args.id,
            // name: args.name,
            );
        break;
      case MainPage.routeName:
        builder = (_) => MainPage();
        break;
      default:
        throw Exception('Invalid route: ${settings.name}');
    }

    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}
