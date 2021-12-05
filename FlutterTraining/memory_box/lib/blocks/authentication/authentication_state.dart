part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class NotAuthenticated extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final UserModel user;

  const Authenticated({required this.user});

  @override
  List<Object> get props => [user];
}
