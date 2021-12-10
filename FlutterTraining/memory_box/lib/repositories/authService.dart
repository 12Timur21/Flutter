import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:memory_box/models/userModel.dart';
import 'package:memory_box/models/verifyAuthModel.dart';

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
        UserModel? userModel =
            await DatabaseService.instance.userModelFromDatabase(uid);

        return userModel;
      }
    }
    return null;
  }

  Future<VerifyAuthModel> verifyPhoneNumberAndSendOTP({
    required String phoneNumber,
  }) async {
    VerifyAuthModel verifyAuthModel = VerifyAuthModel();
    final completer = Completer<String>();
    await _auth.verifyPhoneNumber(
      phoneNumber: '+$phoneNumber',
      timeout: const Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential credential) {
        completer.complete(credential.verificationId);
      },
      verificationFailed: (FirebaseAuthException e) {
        completer.completeError(e.message ?? '');
      },
      codeSent: (verficationIds, resendingToken) {
        completer.complete(verficationIds);
      },
      codeAutoRetrievalTimeout: (String e) {
        completer.completeError(e);
      },
    );

    await completer.future.then((value) {
      verifyAuthModel.verficationIds = value;
    }).catchError((e) {
      verifyAuthModel.error = e;
    });

    return verifyAuthModel;
  }

  Future<UserModel?> verifyOTPCode({
    required String smsCode,
    required String verifictionId,
  }) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verifictionId,
      smsCode: smsCode,
    );
    return await _signInWithPhoneAuthCredential(phoneAuthCredential);
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
          if (user != null) {
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
