part of 'registration_bloc.dart';

@immutable
abstract class RegistrationEvent {
  @override
  List<Object> get props => [];
}

class LoadLoadingPage extends RegistrationEvent {}

class VerifyPhoneNumber extends RegistrationEvent {
  final String phoneNumber;

  VerifyPhoneNumber({
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [phoneNumber];
}

class AnonRegistration extends RegistrationEvent {}

class VerifyOTPCode extends RegistrationEvent {
  final String verifictionId;
  final String smsCode;

  VerifyOTPCode({
    required this.verifictionId,
    required this.smsCode,
  });

  @override
  List<Object> get props => [verifictionId, smsCode];
}
