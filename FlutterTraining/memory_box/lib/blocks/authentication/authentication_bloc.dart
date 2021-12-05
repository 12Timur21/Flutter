import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memory_box/models/userModel.dart';
import 'package:memory_box/services/authService.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService _authService = AuthService.instance;

  AuthenticationBloc() : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppLoaded) {
      yield* _appLoadedToState(event);
    }

    if (event is LogIn) {
      yield* _logInToState();
    }

    if (event is LogOut) {
      yield* _logOutToState(event);
    }

    if (event is DeleteAccount) {
      yield* _deleteUserToState(event);
    }
  }

  Stream<AuthenticationState> _appLoadedToState(AppLoaded event) async* {
    final currentUser = await _authService.currentUser();

    if (currentUser != null) {
      yield Authenticated(user: currentUser);
    } else {
      yield NotAuthenticated();
    }
  }

  Stream<AuthenticationState> _logInToState() async* {
    final currentUser = await _authService.currentUser();

    yield Authenticated(user: currentUser!);
  }

  Stream<AuthenticationState> _logOutToState(
    LogOut event,
  ) async* {
    await _authService.signOut();
    yield NotAuthenticated();
  }

  Stream<AuthenticationState> _deleteUserToState(
    DeleteAccount event,
  ) async* {
    await _authService.deleteAccount();
    yield NotAuthenticated();
  }
}
