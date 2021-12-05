part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppLoaded extends AuthenticationEvent {}

class LogIn extends AuthenticationEvent {}

class LogOut extends AuthenticationEvent {}

class DeleteAccount extends AuthenticationEvent {}
