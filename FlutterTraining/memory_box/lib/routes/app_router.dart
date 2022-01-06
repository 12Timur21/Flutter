import 'package:flutter/material.dart';
import 'package:memory_box/screens/login_screen/login_screens/welcome_regular_user_screen.dart';
import 'package:memory_box/screens/login_screen/registration_screens/gratiude_registration_screen.dart';
import 'package:memory_box/screens/login_screen/registration_screens/registration_screen.dart';
import 'package:memory_box/screens/login_screen/registration_screens/verifyOTP_screen.dart';
import 'package:memory_box/screens/login_screen/registration_screens/welcome_registration_screen.dart';
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

      //*[Start] RegistrationScreen
      case WelcomeRegistrationScreen.routeName:
        builder = (_) => const WelcomeRegistrationScreen();
        break;
      case RegistrationScreen.routeName:
        builder = (_) => const RegistrationScreen();
        break;
      case VerifyOTPScreen.routeName:
        {
          final String args = arguments as String;
          builder = (_) => VerifyOTPScreen(
                verficationId: args,
              );
        }
        break;
      case GratitudeRegistrationScreen.routeName:
        builder = (_) => const GratitudeRegistrationScreen();
        break;
      //*[END] Registration screen

      //*[START] Main page
      case WelcomeRegualrUserScreen.routeName:
        builder = (_) => const WelcomeRegualrUserScreen();
        break;
      case MainPage.routeName:
        builder = (_) => const MainPage();
        break;
      //*[END] Main screen
      default:
        throw Exception('Invalid route: ${settings.name}');
    }

    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}
