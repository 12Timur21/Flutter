import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:memory_box/models/userModel.dart';
import 'package:memory_box/screens/MainPage.dart';
import 'package:memory_box/services/authService.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/circleTextField.dart';
import 'package:memory_box/widgets/continueButton.dart';
import 'package:memory_box/widgets/hintPlate.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class Registration extends StatefulWidget {
  static const routeName = 'Registration';

  Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _textFieldController = TextEditingController();
  // final _otpController = TextEditingController();

  late String verifictionId;

  FirebaseAuth _auth = FirebaseAuth.instance;

  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  void updatePhoneFormatter() {
    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'UA',
      newMask: '+000 (00) 000 00 00',
    );

    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'RU',
      newMask: '+0 (000) 000 00 00',
    );
  }

  void verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+${toNumericString(_textFieldController.text)}',
      verificationCompleted: (_) {
        print('success verfication phone number');
      },
      verificationFailed: (error) {
        print('error verfication phone number');
        print(error);
      },
      codeSent: (verficationIds, resendingToken) async {
        setState(() {
          verifictionId = verficationIds;
          currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
          _textFieldController.text = '';
        });
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  void verifySMSCode() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verifictionId, smsCode: _textFieldController.text);

    AuthService.instance.signInWithPhoneAuthCredential(phoneAuthCredential);
    // .then(
    //   (value) => {
    //     if (value)
    //       {
    //         Navigator.pushNamed(
    //           context,
    //           '/mainPage',
    //         )
    //         // Navigator.push(
    //         //   context,
    //         //   MaterialPageRoute(
    //         //     builder: (context) => MainPage(),
    //         //   ),
    //         // ),
    //       },
    //   },
    // );
  }

  void anonAuth() async {
    AuthService.instance.signInAnon();
    // .then(
    //       (value) => {
    //         if (value)
    //           {
    //             Navigator.pushNamed(
    //               context,
    //               '/mainPage',
    //             )
    //             // Navigator.push(
    //             //   context,
    //             //   MaterialPageRoute(
    //             //     builder: (context) => MainScreen(),
    //             //   ),
    //             // ),
    //           },
    //       },
    //     );
  }

  @override
  void initState() {
    super.initState();
    updatePhoneFormatter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundPattern(
        child: Align(
          alignment: Alignment.center,
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Column(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Регистрация',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'TTNorms',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 6,
                            fontSize: 48,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Text(
                  currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                      ? 'Введи номер телефона'
                      : 'Введи код из смс, чтобы мы тебя запомнили',
                  style: const TextStyle(
                    fontFamily: 'TTNorms',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CircleTextField(
                  controller: _textFieldController,
                  inputFormatters: currentState ==
                          MobileVerificationState.SHOW_MOBILE_FORM_STATE
                      ? [PhoneInputFormatter()]
                      : [],
                ),
                const SizedBox(
                  height: 45,
                ),
                ContinueButton(
                  onPress: () {
                    currentState ==
                            MobileVerificationState.SHOW_MOBILE_FORM_STATE
                        ? verifyPhoneNumber()
                        : verifySMSCode();
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () {
                    log('auth byn pressed');
                    AuthService.instance.signInAnon();
                  },
                  child: const Text(
                    'Позже',
                    style: TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
                Spacer(),
                const HintPlate(
                  label:
                      'Регистрация привяжет твои сказки \n к облаку, после чего они всегда \n будут с тобой',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
