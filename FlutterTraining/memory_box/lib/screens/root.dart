import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/authentication/authentication_bloc.dart';
import 'package:memory_box/blocks/registration/registration_bloc.dart';
import 'package:memory_box/repositories/auth_service.dart';
import 'package:memory_box/screens/splash_screen.dart';
import 'mainPage.dart';
import 'registration/gratitudePage.dart';
import 'registration/registrationPage.dart';
import 'registration/registrationSplash.dart';
import 'registration/verifyOTPPage.dart';

class Root extends StatefulWidget {
  static const routeName = 'RootPage';
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    final _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _authenticationBloc.add(InitAuth());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          // Timer(const Duration(seconds: 3), () {
          //         _authenticationBloc.add(LogIn());
          //       });
          return MainPage();
        }
        if (state.status == AuthenticationStatus.notAuthenticated) {
          //--Not auth --//
          return BlocListener<RegistrationBloc, RegistrationState>(
            listener: (context, state) {
              print(state);
              final _authenticationBloc =
                  BlocProvider.of<AuthenticationBloc>(context);
              if (state is LoginPageLoaded) {
                Navigator.pushNamed(
                  context,
                  RegistrationPage.routeName,
                );

                // RegistrationPage();
              }
              if (state is VerifyPhoneNumberSucces) {
                Navigator.pushNamed(
                  context,
                  VerifyOTPPage.routeName,
                  arguments: state.verificationIds,
                );
                // VerifyOTPPage(
                //   verficationId: state.verifictionId,
                // );
              }
              if (state is VerifyOTPSucces) {
                Timer(const Duration(seconds: 3), () {
                  _authenticationBloc.add(LogIn());
                });
                Navigator.pushNamed(
                  context,
                  GratitudePage.routeName,
                );
                // GratitudePage();
              }

              if (state is AnonRegistrationSucces) {
                _authenticationBloc.add(LogIn());
              }
            },
            child: LoginSpash(),
          );
          //--End not auth --//
        }
        return SplashScreen();
      },
    );
  }
}
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
  // }