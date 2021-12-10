part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {
  const AuthenticationEvent();
}

class InitAuth extends AuthenticationEvent {}

class LogIn extends AuthenticationEvent {}

class LogOut extends AuthenticationEvent {}

class DeleteAccount extends AuthenticationEvent {
  String uid;

  DeleteAccount(this.uid);
}

class UpdateAccount extends AuthenticationEvent {
  String? uid;
  String? displayName;
  String? phoneNumber;
  SubscriptionType? subscriptionType;

  UpdateAccount({
    this.uid,
    this.displayName,
    this.phoneNumber,
    this.subscriptionType,
  });
}
