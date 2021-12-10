import 'package:bloc/bloc.dart';
import 'package:memory_box/models/userModel.dart';
import 'package:memory_box/repositories/authService.dart';
import 'package:memory_box/repositories/databaseService.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationState());

  final AuthService _authService = AuthService.instance;
  final DatabaseService _databaseService = DatabaseService.instance;

  UserModel? currentUser;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    print(event);
    if (event is InitAuth) {
      currentUser = await _authService.currentUser();
      if (currentUser != null) {
        yield AuthenticationState(
          status: AuthenticationStatus.authenticated,
          user: currentUser,
        );
      } else {
        yield AuthenticationState(
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
      yield AuthenticationState(
        status: AuthenticationStatus.notAuthenticated,
        user: null,
      );
    }

    if (event is DeleteAccount) {
      currentUser = null;
      await _databaseService.deleteUserCollections(event.uid);
      await _authService.deleteAccount();

      yield AuthenticationState(
        status: AuthenticationStatus.notAuthenticated,
        user: null,
      );
    }

    if (event is UpdateAccount) {
      currentUser = await _authService.currentUser();
      yield AuthenticationState(
        status: AuthenticationStatus.notAuthenticated,
        user: currentUser?.copyWith(
          uid: event.uid,
          displayName: event.displayName,
          phoneNumber: event.phoneNumber,
          subscriptionType: event.subscriptionType,
        ),
      );
    }
  }
}
