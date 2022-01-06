import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memory_box/models/user_model.dart';
import 'package:memory_box/repositories/auth_service.dart';
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
      _authService.verifyPhoneNumberAndSendOTP(
        phoneNumber: event.phoneNumber,
        codeAutoRetrievalTimeout: () {
          print('VerifyTimeEnd');
          emit(VerifyTimeEnd());
        },
        codeSent: (String verficationIds, int? resendingToken) {
          print('codeSent');
          emit(VerifyPhoneNumberSucces(
            verificationIds: verficationIds,
            resendingToken: resendingToken,
          ));
        },
        verificationFailed: (String? error) {
          print('verificationFailed 222');
          emit(VerifyPhoneNumberFailure(error: error));
        },
        verificationCompleted: (PhoneAuthCredential credential) {
          print('verificationCompleted');
          print('verificationCompleted');
        },
      );
    }
    if (event is VerifyOTPCode) {
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
      } else {
        yield AnonRegistrationFailrule();
      }
    }

    if (event is LoadLoadingPage) {
      yield LoginPageLoaded();
    }
  }
}
