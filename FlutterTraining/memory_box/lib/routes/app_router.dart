import 'package:flutter/material.dart';
import 'package:memory_box/screens/login/gratitudePage.dart';
import 'package:memory_box/screens/login/loginPage.dart';
import 'package:memory_box/screens/login/verifyOTPPage.dart';
import 'package:memory_box/screens/mainPage.dart';
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

      case LoginPage.routeName:
        builder = (_) => const LoginPage();
        break;

      case VerifyOTPPage.routeName:
        {
          final String args = arguments as String;
          builder = (_) => VerifyOTPPage(
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
