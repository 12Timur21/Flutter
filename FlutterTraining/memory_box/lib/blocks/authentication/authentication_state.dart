part of 'authentication_bloc.dart';

enum AuthenticationStatus { initial, authenticated, notAuthenticated, failure }

@immutable
class AuthenticationState {
  final AuthenticationStatus status;
  final UserModel? user;

  const AuthenticationState({
    this.status = AuthenticationStatus.initial,
    this.user,
  });
}
