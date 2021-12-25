import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:memory_box/models/user_model.dart';
import 'package:memory_box/models/verify_auth_model.dart';

import 'database_service.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  const AuthService._();
  static const AuthService instance = AuthService._();

  static String? userID;

  Future<UserModel?> currentUser() async {
    String? uid = _auth.currentUser?.uid;
    userID = uid;
    if (uid != null) {
      bool isUserExist = await DatabaseService.instance.isUserExist();
      if (isUserExist) {
        UserModel? userModel =
            await DatabaseService.instance.userModelFromDatabase();

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
        print(resendingToken);
        print('qeqeqeq');
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
        userID = uid;
        UserModel? userModel;
        User? user = result.user;

        bool isUserExist = await DatabaseService.instance.isUserExist();

        if (isUserExist) {
          userModel = await DatabaseService.instance.userModelFromDatabase();
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
        userID = userModel.uid;
      }
      return userModel;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    userID = null;
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

  Future<void> updatePhoneNumber(
    PhoneAuthCredential phoneAuthCredential,
  ) async {
    _auth.currentUser?.updatePhoneNumber(phoneAuthCredential);
  }
}