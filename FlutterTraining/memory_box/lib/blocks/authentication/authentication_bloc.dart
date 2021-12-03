import 'package:bloc/bloc.dart';
import 'package:memory_box/models/userModel.dart';
import 'package:memory_box/services/authService.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService _authService = AuthService.instance;

  AuthenticationBloc() : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    }

    if (event is LogIn) {
      // yield* _mapUserLoggedInToState();
    }

    if (event is LogOut) {
      yield* _mapUserLoggedOutToState(event);
    }
  }

  Stream<AuthenticationState> _mapAppLoadedToState(AppLoaded event) async* {
    //?await Future.delayed(Duration(milliseconds: 500));
    final currentUser = await _authService.currentUser();

    if (currentUser != null) {
      yield Authenticated(user: currentUser);
    } else {
      yield NotAuthenticated();
    }
  }

  Stream<AuthenticationState> _mapUserLoggedInToState(
    LogIn event,
  ) async* {
    // yield Authenticated(user: event.user);
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState(
    LogOut event,
  ) async* {
    await _authService.signOut();
    yield NotAuthenticated();
  }

  Stream<AuthenticationState> _deleteUser(
    DeleteAccount event,
  ) async* {
    await _authService.deleteAccount();
    yield NotAuthenticated();
  }
}
