import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/bottom_navigation_index_control/bottom_navigation_index_control_cubit.dart';
import 'package:memory_box/blocks/session/session_bloc.dart';
import 'package:memory_box/routes/app_router.dart';
import 'package:memory_box/screens/splash_screen.dart';
import 'package:memory_box/settings/initial_settings.dart';
import 'blocks/registration/registration_bloc.dart';

// void initDeepLink() {
//   FirebaseDynamicLinks.instance.onLink.listen((event) {
//     final Uri? deepLink = event.link;

//     if (deepLink != null) {
//       print(deepLink);
//     }
//   });
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // initDeepLink();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavigationIndexControlCubit>(
          create: (BuildContext context) {
            return BottomNavigationIndexControlCubit();
          },
        ),
        BlocProvider<RegistrationBloc>(
          create: (BuildContext context) {
            return RegistrationBloc();
          },
        ),
        BlocProvider<SessionBloc>(
          create: (BuildContext context) {
            return SessionBloc();
          },
        ),
      ],
      child: const MyApp(),
    ),
  );

  InitialSettings();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Memory Box',
      initialRoute: SplashScreen.routeName,
      onGenerateRoute: AppRouter.generateRoute,
      home: const SplashScreen(),
      theme: ThemeData(
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontFamily: 'TTNorms',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}

//? Убирает физику "подтягивания" у скрола
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
