import 'package:flutter/material.dart';
import 'package:memory_box/screens/mainPage.dart';
import 'package:memory_box/screens/registration/gratitudePage.dart';
import 'package:memory_box/screens/registration/registrationPage.dart';
import 'package:memory_box/screens/registration/verifyOTPPage.dart';
import 'package:memory_box/screens/root.dart';
import 'package:memory_box/screens/subscriptionPage.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? arguments = settings.arguments;

    WidgetBuilder builder;

    switch (settings.name) {
      case Root.routeName:
        builder = (_) => const Root();
        break;

      case RegistrationPage.routeName:
        builder = (_) => const RegistrationPage();
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
