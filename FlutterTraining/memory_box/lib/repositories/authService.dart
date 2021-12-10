import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:memory_box/models/userModel.dart';

import 'databaseService.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  const AuthService._();
  static const AuthService instance = AuthService._();

  Future<UserModel?> currentUser() async {
    String? uid = _auth.currentUser?.uid;

    if (uid != null) {
      bool isUserExist = await DatabaseService.instance.isUserExist(uid);
      if (isUserExist) {
        return await DatabaseService.instance.userModelFromDatabase(uid);
      }
    }
    return null;
  }

  Future<PhoneAuthCredential?> verifyPhoneNumberAndSendOTP({
    required String phoneNumber,
    required Function onSucces,
    required Function onError,
    required Function onTimeOut,
  }) async {
    final completer = Completer<String>();
    String? ids;
    int? token;
    print('1');
    await _auth.verifyPhoneNumber(
      phoneNumber: '+$phoneNumber',
      timeout: const Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential credential) {
        print('test');
        completer.complete(credential.verificationId);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('test2');
        completer.completeError(e);
      },
      codeSent: (verficationIds, resendingToken) {
        ids = verficationIds;
        token = resendingToken;
        print('test3');
        completer.complete(verficationIds);
      },
      codeAutoRetrievalTimeout: (String e) {
        completer.completeError(e);
        print('test4');
      },
    );
    print('2');
    String zxc = await completer.future;
    print(zxc);
    // try {
    //   print(completer.isCompleted);
    //   print('3');

    //   print(credential2?.verificationId);
    //   print('4');
    //   onSucces(ids, token);
    //   // return await verificationComplete(credential);
    // } catch (e) {
    //   print('5');
    //   onError();
    // }
  }

  Future<void> verifyOTPCode({
    required String smsCode,
    required String verifictionId,
    required Function onSucces,
    required Function onError,
  }) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verifictionId,
      smsCode: smsCode,
    );
    await _signInWithPhoneAuthCredential(phoneAuthCredential)
        .then((user) => onSucces(user))
        .onError(
          (_, __) => onError(),
        );
  }

  Future<UserModel?> _signInWithPhoneAuthCredential(
    PhoneAuthCredential phoneAuthCredential,
  ) async {
    try {
      UserCredential result =
          await _auth.signInWithCredential(phoneAuthCredential);
      String? uid = result.user?.uid;
      if (uid != null) {
        UserModel? userModel;
        User? user = result.user;

        bool isUserExist = await DatabaseService.instance.isUserExist(uid);

        if (isUserExist) {
          userModel = await DatabaseService.instance.userModelFromDatabase(uid);
        } else {
          if (result.user != null && user != null) {
            userModel = _firebaseModeltoUserModel(user);
            if (userModel != null) {
              DatabaseService.instance.recordNewUser(userModel);
            }
          }
        }
        return userModel;
      }
    } on FirebaseAuthException catch (_) {
      return null;
    }
  }

  Future<UserModel?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      UserModel? userModel = _firebaseModeltoUserModel(user);
      if (userModel != null) {
        DatabaseService.instance.recordNewUser(userModel);
      }
      return userModel;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }

  UserModel? _firebaseModeltoUserModel(User? user) {
    return user != null
        ? UserModel(
            uid: user.uid,
            phoneNumber: user.phoneNumber,
            displayName: user.displayName,
            subscriptionType: SubscriptionType.noSubscription,
          )
        : null;
  }

  bool isAuth() {
    return _auth.currentUser == null ? false : true;
  }
}
