import 'package:bloc/bloc.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:memory_box/models/user_model.dart';
import 'package:memory_box/repositories/auth_service.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:meta/meta.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc()
      : super(const SessionState(
          status: SessionStatus.initial,
        ));

  final AuthService _authService = AuthService.instance;
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Stream<SessionState> mapEventToState(
    SessionEvent event,
  ) async* {
    if (event is InitSession) {
      print('called');
      UserModel? currentUser = await _authService.currentUser();

      if (currentUser != null) {
        print('this');
        yield SessionState(
          status: SessionStatus.authenticated,
          user: currentUser,
        );
      } else {
        print('not this');
        yield const SessionState(
          status: SessionStatus.notAuthenticated,
          user: null,
        );
      }
    }

    if (event is LogIn) {
      UserModel? currentUser = await _authService.currentUser();

      yield SessionState(
        status: SessionStatus.authenticated,
        user: currentUser,
      );
    }

    if (event is LogOut) {
      await _authService.signOut();

      yield const SessionState(
        status: SessionStatus.notAuthenticated,
        user: null,
      );
    }

    if (event is DeleteAccount) {
      await _databaseService.deleteUserFromFirebase();
      await _authService.deleteAccount();

      yield const SessionState(
        status: SessionStatus.notAuthenticated,
        user: null,
      );
    }

    if (event is UpdateAccount) {
      UserModel? currentUser = await _authService.currentUser();
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

      yield SessionState(
        status: SessionStatus.authenticated,
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
