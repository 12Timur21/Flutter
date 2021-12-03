import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/blocks/authentication/authentication_bloc.dart';
import 'package:memory_box/models/userModel.dart';
import 'package:memory_box/services/authService.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  // final AuthenticationBloc _authenticationBloc;
  final AuthService _authService = AuthService.instance;

  LoginBloc(
      // this._authenticationBloc,
      )
      : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is VerifyPhoneNumber) {
      yield* _mapLoginWithPhoneToState(event);
    }
    if (event is VerifyOTPCode) {
      yield* _mapValidateWithPhoneOTPToState(event);
    }
    if (event is LoadLoadingPage) {
      yield* _mapLoginWithLoginLoadedState();
    }
  }

  Stream<LoginState> _mapLoginWithLoginLoadedState() async* {
    yield LoginLoaded();
  }

  Stream<LoginState> _mapLoginWithPhoneToState(
    VerifyPhoneNumber event,
  ) async* {
    yield LoginLoading();
    _authService.verifyPhoneNumberAndSendOTP(
      phoneNumber: event.phoneNumber,
      onSucces: (String verficationIds, int? resendingToken) async* {
        print('$verficationIds $resendingToken');
        yield VerifyPhoneNumberSucces(verifictionId: verficationIds);
      },
      onError: (FirebaseAuthException e) async* {
        yield VerifyPhoneFailure(error: e.message);
      },
      onTimeOut: (FirebaseAuthException e) async* {
        yield VerifyPhoneFailure(error: e.message);
      },
    );
  }

  Stream<LoginState> _mapValidateWithPhoneOTPToState(
    VerifyOTPCode event,
  ) async* {
    yield LoginLoading();
    _authService.verifyOTPCode(
      smsCode: event.verifictionId,
      verifictionId: event.verifictionId,
      onSucces: () async* {
        yield VerifyOTPSucces();
      },
      onError: () async* {
        yield VerifyOTPFailure();
      },
    );
  }
}
