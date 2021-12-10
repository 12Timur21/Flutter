import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:memory_box/blocks/authentication/authentication_bloc.dart';
import 'package:memory_box/blocks/registration/registration_bloc.dart';
import 'package:memory_box/repositories/authService.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/circleTextField.dart';
import 'package:memory_box/widgets/continueButton.dart';
import 'package:memory_box/widgets/hintPlate.dart';

class RegistrationPage extends StatefulWidget {
  static const routeName = 'Registration';

  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<RegistrationPage> {
  final _textFieldController = TextEditingController();

  void anonAuth() async {
    await AuthService.instance.signInAnon();
    final _authBloc = BlocProvider.of<AuthenticationBloc>(context);

    _authBloc.add(LogIn());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    void verifyPhoneNumber() {
      final _registrationBloc = BlocProvider.of<RegistrationBloc>(context);
      _registrationBloc.add(
        VerifyPhoneNumber(
          phoneNumber: toNumericString(_textFieldController.text),
        ),
      );
    }

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
                    'Введи номер телефона',
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
                    controller: _textFieldController,
                    inputFormatters: [PhoneInputFormatter()],
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  ContinueButton(
                    onPress: () {
                      verifyPhoneNumber();
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () {
                      anonAuth();
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
