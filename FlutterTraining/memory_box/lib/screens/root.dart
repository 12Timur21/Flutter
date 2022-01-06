import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/session/session_bloc.dart';
import 'package:memory_box/screens/login_screen/login_screens/welcome_regular_user_screen.dart';
import 'package:memory_box/screens/login_screen/registration_screens/welcome_registration_screen.dart';
import 'mainPage.dart';

import 'splash_screen.dart';

class Root extends StatefulWidget {
  static const routeName = 'RootPage';
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    //Инициализация через 3 секунды
    Future.delayed(const Duration(seconds: 3), () {
      context.read<SessionBloc>().add(InitSession());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listener: (context, state) {
        if (state.status == SessionStatus.authenticated) {
          Navigator.pushNamed(
            context,
            WelcomeRegualrUserScreen.routeName,
          );
        }
        if (state.status == SessionStatus.notAuthenticated) {
          Navigator.pushNamed(
            context,
            WelcomeRegistrationScreen.routeName,
          );
        }
      },
      child: const SplashScreen(),
    );
  }
}
