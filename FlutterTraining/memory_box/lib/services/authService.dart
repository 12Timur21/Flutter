import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:memory_box/models/userModel.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  const AuthService._();

  static const AuthService instance = AuthService._();

  // late String verifictionId;

  void verifyPhoneNumber({
    required String phoneNumber,
    required Function onSucces,
    required Function onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+$phoneNumber',
      verificationCompleted: (_) {
        log('success verfication phone number');
      },
      verificationFailed: (FirebaseAuthException e) {
        log('unsuccess verfication phone number');
        onError(e);
      },
      codeSent: (verficationIds, resendingToken) async {
        print('sms code send throw callback');
        onSucces(verficationIds);
      },
      codeAutoRetrievalTimeout: (_) async {},
    );
  }

  void verifySMSCode(
      {required String smsCode,
      required Function onSucces,
      required Function onError,
      required String verifictionId}) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verifictionId, smsCode: smsCode);

    AuthService.instance
        .signInWithPhoneAuthCredential(phoneAuthCredential)
        .then((_) => onSucces())
        .onError(
          (_, __) => onError(),
        );
  }

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
    if (_auth.currentUser != null) {
      log('is auth - true');
      return true;
    }
    log('is auth - false');
    return false;
  }

  Future signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      UserCredential result =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (result.user != null) {
        log('successful phone auth');
        return _userDataFromFirebaseUser(result.user);
      }
    } on FirebaseAuthException catch (_) {
      log('unsuccessful phone auth');
      return null;
    }
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      log('sign in anon');
      return _userDataFromFirebaseUser(result.user);
    } catch (e) {
      log('failed sign in anon');
      log(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      log('sign out');
      return await _auth.signOut();
    } catch (e) {
      log('failed sign out');
      log(e.toString());
    }
  }

  Future deleteAccount() async {
    try {
      log('sign out');
      return await _auth.currentUser?.delete();
    } catch (e) {
      log('failed delete account');
      log(e.toString());
    }
  }
}
