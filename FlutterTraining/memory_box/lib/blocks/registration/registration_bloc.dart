import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/models/userModel.dart';
import 'package:memory_box/repositories/authService.dart';
import 'package:meta/meta.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  // final AuthenticationBloc _authenticationBloc;
  final AuthService _authService = AuthService.instance;

  RegistrationBloc(
      // this._authenticationBloc,
      )
      : super(LoginInitial());

  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (event is VerifyPhoneNumber) {
      String? error;
      String? verficationId;

      PhoneAuthCredential? p = await _authService.verifyPhoneNumberAndSendOTP(
        phoneNumber: event.phoneNumber,
        onSucces: (String verficationIds, int? resendingToken) {
          verficationId = verficationIds;
          print(verficationIds);
        },
        onError: (FirebaseAuthException e) {
          error = e.message;
        },
        onTimeOut: (String e) {
          error = e;
        },
      );
      print('11');
      print(p?.verificationId);
      print('22');
      if (error == null && verficationId != null) {
        yield VerifyPhoneNumberSucces(verificationIds: verficationId!);
      } else {
        yield VerifyPhoneFailure(
          error: error,
        );
      }
    }
    if (event is VerifyOTPCode) {
      bool error = false;
      UserModel? userModel;

      _authService.verifyOTPCode(
        smsCode: event.verifictionId,
        verifictionId: event.verifictionId,
        onSucces: (UserModel? user) {
          userModel = user;
        },
        onError: () {
          error = true;
        },
      );

      if (!error && userModel != null) {
        yield VerifyOTPSucces(user: userModel!);
      } else {
        yield VerifyOTPFailure();
      }
    }
    if (event is LoadLoadingPage) {
      yield LoginPageLoaded();
    }
  }
}
