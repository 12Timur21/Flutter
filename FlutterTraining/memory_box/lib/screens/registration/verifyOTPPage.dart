import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/registration/registration_bloc.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/circle_textField.dart';
import 'package:memory_box/widgets/continue_button.dart';
import 'package:memory_box/widgets/hintPlate.dart';

class VerifyOTPPage extends StatefulWidget {
  static const routeName = 'VerifyPin';
  String verficationId;
  VerifyOTPPage({required this.verficationId, Key? key}) : super(key: key);

  @override
  _VerifyOTPPageState createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends State<VerifyOTPPage> {
  final _otpController = TextEditingController();

  void verifySMSCode() async {
    final _loginBloc = BlocProvider.of<RegistrationBloc>(context);
    _loginBloc.add(
      VerifyOTPCode(
        smsCode: _otpController.text,
        verifictionId: widget.verficationId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BackgroundPattern(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: height,
              child: Column(
                children: [
                  Container(
                    height: 275,
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
                  const Text(
                    'Введи код из смс, чтобы мы тебя запомнили',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CircleTextField(
                    controller: _otpController,
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  ContinueButton(
                    onPress: () {
                      verifySMSCode();
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Spacer(),
                  const HintPlate(
                    label:
                        'Регистрация привяжет твои сказки \n к облаку, после чего они всегда \n будут с тобой',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
