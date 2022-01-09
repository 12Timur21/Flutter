import 'package:flutter/material.dart';
import 'package:memory_box/blocks/playListNavigation/playListNavigation_bloc.dart';
import 'package:memory_box/screens/all_tales_screen/all_tales_screen.dart';
import 'package:memory_box/screens/deleted_tales_screen/deleted_tales_screen.dart';
import 'package:memory_box/screens/home_screen/home_screen.dart';
import 'package:memory_box/screens/login_screen/login_screens/welcome_regular_user_screen.dart';
import 'package:memory_box/screens/login_screen/registration_screens/gratiude_registration_screen.dart';
import 'package:memory_box/screens/login_screen/registration_screens/registration_screen.dart';
import 'package:memory_box/screens/login_screen/registration_screens/verifyOTP_screen.dart';
import 'package:memory_box/screens/login_screen/registration_screens/welcome_registration_screen.dart';
import 'package:memory_box/screens/mainPage.dart';
import 'package:memory_box/screens/playlist_screen/create_playlist_screen.dart';
import 'package:memory_box/screens/playlist_screen/playlist_screen.dart';
import 'package:memory_box/screens/playlist_screen/select_playlist_tales.dart';
import 'package:memory_box/screens/profile_screen/profile_screen.dart';
import 'package:memory_box/screens/search_tales_screen/search_tales_screen.dart';
import 'package:memory_box/screens/splash_screen.dart';
import 'package:memory_box/screens/subscription_screen/subscription_screen.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? arguments = settings.arguments;

    WidgetBuilder builder;

    print('settings name : ${settings.name}');

    switch (settings.name) {
      case SplashScreen.routeName:
        builder = (_) => const SplashScreen();
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

      case ProfileScreen.routeName:
        builder = (_) => const ProfileScreen();
        break;

      case HomeScreen.routeName:
        builder = (_) => const HomeScreen();
        break;

      case DeletedTalesScreen.routeName:
        builder = (_) => const DeletedTalesScreen();
        break;

      case SearchTalesScreen.routeName:
        builder = (_) => const SearchTalesScreen();
        break;

      //*[START] Play list
      case PlaylistScreen.routeName:
        builder = (_) => const PlaylistScreen();
        break;

      case CreatePlaylistScreen.routeName:
        {
          final PlayListCreationState? args =
              arguments as PlayListCreationState?;

          builder = (_) => CreatePlaylistScreen(
                collectionCreationState: args,
              );
        }
        break;

      case SelectPlaylistTales.routeName:
        {
          final PlayListCreationState? args =
              arguments as PlayListCreationState?;

          builder = (_) => SelectPlaylistTales(
                collectionCreationState: args,
              );
        }
        break;
      //*[END] Play list

      case SubscriptionScreen.routeName:
        builder = (_) => const SubscriptionScreen();
        break;

      case AllTalesScreen.routeName:
        builder = (_) => const AllTalesScreen();
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
