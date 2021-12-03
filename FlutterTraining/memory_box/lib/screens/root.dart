import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/authentication/authentication_bloc.dart';
import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_bloc.dart';
import 'package:memory_box/blocks/login/login_bloc.dart';
import 'package:memory_box/screens/login/gratitudePage.dart';
import 'package:memory_box/screens/login/loginPage.dart';
import 'package:memory_box/screens/mainPage.dart';
import 'package:memory_box/screens/splashScreen.dart';

import 'login/loginSplash.dart';
import 'login/verifyOTPPage.dart';

class Root extends StatefulWidget {
  static const routeName = 'RootPage';
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return MainPage();
    // final _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    // return BlocBuilder<AuthenticationBloc, AuthenticationState>(
    //   builder: (context, state) {
    //     if (state is Authenticated) {
    //       return MainPage();
    //     }
    //     if (state is NotAuthenticated) {
    //       return BlocBuilder<LoginBloc, LoginState>(
    //         builder: (context, state) {
    //           if (state is LoginInitial) {
    //             return const LoginSpash();
    //           }
    //           if (state is LoginLoaded) {
    //             return const LoginPage();
    //           }
    //           if (state is VerifyPhoneNumberSucces) {
    //             return VerifyOTPPage(
    //               verficationId: state.verifictionId,
    //             );
    //           }
    //           if (state is VerifyOTPSucces) {
    //             Timer(Duration(seconds: 3), () {
    //               _authenticationBloc.add(LogIn());
    //             });
    //             return GratitudePage();
    //           }
    //           return const Placeholder();
    //         },
    //       );
    //     }
    //     return SplashScreen();
    //   },
    // listener: (context, state) {
    //   if (state is AuthenticationInitial) {
    //     _authenticationBloc.add(
    //       AppLoaded(),
    //     );
    //   }
    //   if (state is Authenticated) {
    //     // return MainPage();
    //     Navigator.pushReplacementNamed(
    //       context,
    //       MainPage.routeName,
    //       // arguments: verficationId,
    //     );
    //   } else if (state is NotAuthenticated) {
    //     Navigator.pushReplacementNamed(
    //       context,
    //       LoginPage.routeName,
    //     );
    //   }
    // },
  }
}
