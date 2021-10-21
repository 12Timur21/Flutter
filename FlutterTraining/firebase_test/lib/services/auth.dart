import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/models/userData.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserData? _userDataFromFirebaseUser(User? user) {
    return user != null ? UserData(uid: user.uid) : null;
  }

  Stream<UserData?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userDataFromFirebaseUser(user!));
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userDataFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
