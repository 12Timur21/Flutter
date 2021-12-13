import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/models/userModel.dart';
import 'package:memory_box/models/verifyAuthModel.dart';
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
      VerifyAuthModel varifyAuthModel =
          await _authService.verifyPhoneNumberAndSendOTP(
        phoneNumber: event.phoneNumber,
      );

      String? error = varifyAuthModel.error;
      String? verficationId = varifyAuthModel.verficationIds;

      if (error == null && verficationId != null) {
        yield VerifyPhoneNumberSucces(
          verificationIds: verficationId,
        );
      } else {
        yield VerifyPhoneFailure(
          error: error,
        );
      }
    }
    if (event is VerifyOTPCode) {
      print(event.smsCode);
      print(event.verifictionId);
      UserModel? userModel = await _authService.verifyOTPCode(
        smsCode: event.smsCode,
        verifictionId: event.verifictionId,
      );

      if (userModel != null) {
        yield VerifyOTPSucces(user: userModel);
      } else {
        yield VerifyOTPFailure();
      }
    }

    if (event is AnonRegistration) {
      UserModel? userModel = await _authService.signInAnon();
      if (userModel != null) {
        yield AnonRegistrationSucces(user: userModel);
      }
    }

    if (event is LoadLoadingPage) {
      yield LoginPageLoaded();
    }
  }
}
