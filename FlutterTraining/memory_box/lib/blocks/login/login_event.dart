part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {
  @override
  List<Object> get props => [];
}

class LoadLoadingPage extends LoginEvent {}

class VerifyPhoneNumber extends LoginEvent {
  final int phoneNumber;

  VerifyPhoneNumber({
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyOTPCode extends LoginEvent {
  final String verifictionId;
  final String smsCode;

  VerifyOTPCode({
    required this.verifictionId,
    required this.smsCode,
  });

  @override
  List<Object> get props => [verifictionId, smsCode];
}
