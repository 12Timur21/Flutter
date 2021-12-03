import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/authentication/authentication_bloc.dart';
import 'package:memory_box/blocks/login/login_bloc.dart';
import 'package:memory_box/models/userModel.dart';
import 'package:memory_box/routes/app_router.dart';
import 'package:memory_box/screens/root.dart';
import 'package:memory_box/services/authService.dart';
import 'package:memory_box/settings/initialSettings.dart';
import 'package:provider/provider.dart';

import 'blocks/mainPageNavigation/navigation_bloc.dart';
import 'blocks/mainPageNavigation/navigation_state.dart';
import 'blocks/recorderButton/recorderButton_bloc.dart';
import 'blocks/recorderButton/recorderButton_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc(
            const NavigationState(
              selectedItem: NavigationPages.HomePage,
            ),
          ),
        ),
        BlocProvider<RecorderButtomBloc>(
          create: (BuildContext context) {
            return RecorderButtomBloc(
              const RecorderButtonState(
                selectedIcon: RecorderButtonStates.WithIcon,
              ),
            );
          },
        ),
        BlocProvider<LoginBloc>(
          create: (BuildContext context) {
            return LoginBloc();
          },
        ),
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) {
            return AuthenticationBloc();
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
    return StreamProvider<UserModel?>.value(
      value: AuthService.instance.user,
      initialData: null,
      catchError: (_, __) => null,
      child: MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        title: 'Memory Box',
        initialRoute: Root.routeName,
        onGenerateRoute: AppRouter.generateRoute,
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
