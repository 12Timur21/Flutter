import 'package:flutter/material.dart';
import 'package:memory_box/screens/Registration/gratitudePage.dart';
import 'package:memory_box/screens/Registration/verifyPinPage.dart';
import 'package:memory_box/screens/mainPage.dart';
import 'package:memory_box/screens/Registration/registration.dart';
import 'package:memory_box/screens/root.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? arguments = settings.arguments;

    WidgetBuilder builder;

    switch (settings.name) {
      case Root.routeName:
        builder = (_) => const Root();
        break;

      case Registration.routeName:
        builder = (_) => Registration();
        break;

      case VerifyPinPage.routeName:
        {
          final String args = arguments as String;
          builder = (_) => VerifyPinPage(
                verficationId: args,
              );
        }
        break;

      case GratitudePage.routeName:
        builder = (_) => const GratitudePage();
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
