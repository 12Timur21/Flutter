part of 'login_bloc.dart';

@immutable
abstract class LoginState {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoaded extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class VerifyPhoneNumberSucces extends LoginState {
  final String verifictionId;

  VerifyPhoneNumberSucces({required this.verifictionId});

  @override
  List<Object> get props => [verifictionId];
}

class VerifyPhoneFailure extends LoginState {
  final String? error;

  VerifyPhoneFailure({required this.error});
}

class VerifyOTPSucces extends LoginState {}

class VerifyOTPFailure extends LoginState {}
