part of 'session_bloc.dart';

abstract class SessionEvent {
  const SessionEvent();
}

class InitSession extends SessionEvent {}

class LogIn extends SessionEvent {}

class LogOut extends SessionEvent {}

class DeleteAccount extends SessionEvent {
  final String uid;

  DeleteAccount({
    required this.uid,
  });
}

class UpdateAccount extends SessionEvent {
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
