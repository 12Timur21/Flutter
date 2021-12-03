import 'dart:developer';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:memory_box/models/userModel.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  const AuthService._();

  static const AuthService instance = AuthService._();

  Future<UserModel?> currentUser() async {
    return _firebaseModeltoUserModel(_auth.currentUser);
  }

  Future<void> verifyPhoneNumberAndSendOTP({
    required int phoneNumber,
    required Function onSucces,
    required Function onError,
    required Function onTimeOut,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+$phoneNumber',
      timeout: const Duration(days: 1),
      verificationCompleted: (verificationCompleted) {
        print('verificationcompleted');
        print(verificationCompleted.smsCode);
        print(verificationCompleted.verificationId);
        print(verificationCompleted.token);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e);
      },
      codeSent: (verficationIds, resendingToken) {
        print('codeSent');
        onSucces(verficationIds, resendingToken);
      },
      codeAutoRetrievalTimeout: (e) {
        onTimeOut(e);
      },
    );
  }

  void verifyOTPCode({
    required String smsCode,
    required String verifictionId,
    required Function onSucces,
    required Function onError,
  }) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verifictionId,
      smsCode: smsCode,
    );

    _signInWithPhoneAuthCredential(phoneAuthCredential)
        .then((_) => onSucces())
        .onError(
          (_, __) => onError(),
        );
  }

  Future<UserModel?> _signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      UserCredential result =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (result.user != null) {
        log('successful phone auth');
        return _firebaseModeltoUserModel(result.user);
      }
    } on FirebaseAuthException catch (_) {
      log('unsuccessful phone auth');
      return null;
    }
  }

  Future<UserModel?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      log('sign in anon');
      return _firebaseModeltoUserModel(result.user);
    } catch (e) {
      log('failed sign in anon');
      log(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    // try {
    await _auth.signOut();
    // } catch (e) {
    //   return ;
    // }
  }

  Future deleteAccount() async {
    // try {
    return await _auth.currentUser?.delete();
    // } catch (e) {
    //   log('failed delete account');
    //   log(e.toString());
    // }
  }

  UserModel? _firebaseModeltoUserModel(User? user) {
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
        .map((User? user) => _firebaseModeltoUserModel(user!));
  }

  bool get isAuth {
    if (_auth.currentUser != null) {
      return true;
    }
    return false;
  }
}
