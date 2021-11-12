import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:memory_box/models/userModel.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  const AuthService._();

  static const AuthService instance = AuthService._();

  UserModel? _userDataFromFirebaseUser(User? user) {
    return user != null
        ? UserModel(
            uid: user.uid,
            phoneNumber: user.displayName,
            displayName: user.displayName,
          )
        : null;
  }

  Stream<UserModel?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userDataFromFirebaseUser(user!));
  }

  bool get isAuth {
    if (_auth.currentUser != null) return true;
    return false;
  }

  Future signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      UserCredential result =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (result.user != null) {
        return _userDataFromFirebaseUser(result.user);
      }
    } on FirebaseAuthException catch (_) {
      return null;
    }
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return _userDataFromFirebaseUser(result.user);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      log(e.toString());
    }
  }
}
