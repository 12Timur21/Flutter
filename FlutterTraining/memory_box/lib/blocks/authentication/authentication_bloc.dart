import 'package:bloc/bloc.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:memory_box/models/user_model.dart';
import 'package:memory_box/repositories/auth_service.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const AuthenticationState());

  final AuthService _authService = AuthService.instance;
  final DatabaseService _databaseService = DatabaseService.instance;

  UserModel? currentUser;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is InitAuth) {
      currentUser = await _authService.currentUser();
      if (currentUser != null) {
        yield AuthenticationState(
          status: AuthenticationStatus.authenticated,
          user: currentUser,
        );
      } else {
        yield const AuthenticationState(
          status: AuthenticationStatus.notAuthenticated,
          user: null,
        );
      }
    }

    if (event is LogIn) {
      currentUser = await _authService.currentUser();
      yield AuthenticationState(
        status: AuthenticationStatus.authenticated,
        user: currentUser,
      );
    }

    if (event is LogOut) {
      currentUser = null;
      await _authService.signOut();
      yield const AuthenticationState(
        status: AuthenticationStatus.notAuthenticated,
        user: null,
      );
    }

    if (event is DeleteAccount) {
      currentUser = null;
      await _databaseService.deleteUserFromFirebase();
      await _authService.deleteAccount();

      yield const AuthenticationState(
        status: AuthenticationStatus.notAuthenticated,
        user: null,
      );
    }

    if (event is UpdateAccount) {
      currentUser = await _authService.currentUser();
      String? uid = event.uid;

      // PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credentialFromToken();

      if (uid != null) {
        await _databaseService.updateUserCollection(
          // uid: uid,
          phoneNumber: event.phoneNumber != null
              ? toNumericString(event.phoneNumber)
              : null,
          displayName: event.displayName,
        );

        // await _authService.updatePhoneNumber()
      }

      yield AuthenticationState(
        status: AuthenticationStatus.authenticated,
        user: currentUser?.copyWith(
          uid: uid,
          displayName: event.displayName,
          phoneNumber: event.phoneNumber,
          subscriptionType: event.subscriptionType,
        ),
      );
    }
  }
}
