import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/models/userData.dart';
import 'package:firebase_test/services/dataBaseService.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  UserData? _userDataFromFirebaseUser(User? user) {
    return user != null ? UserData(uid: user.uid) : null;
  }

  Stream<UserData?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userDataFromFirebaseUser(user!));
  }

  Future registerWithEmailAndPasswor(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      await DatabaseService(uid: user?.uid)
          .updateUserData('0', 'new crew member', 100);
      return _userDataFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userDataFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
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
