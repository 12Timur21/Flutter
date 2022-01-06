import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:memory_box/blocks/registration/registration_bloc.dart';
import 'package:memory_box/blocks/session/session_bloc.dart';
import 'package:memory_box/screens/login_screen/registration_screens/verifyOTP_screen.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/circle_textField.dart';
import 'package:memory_box/widgets/continue_button.dart';
import 'package:memory_box/widgets/hintPlate.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = 'RegistrationScreen';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<RegistrationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void anonAuth() async {
      BlocProvider.of<RegistrationBloc>(context).add(
        AnonRegistration(),
      );
    }

    void verifyPhoneNumber() {
      if (_formKey.currentState!.validate()) {
        FocusScope.of(context).requestFocus(FocusNode());
        BlocProvider.of<RegistrationBloc>(context).add(
          VerifyPhoneNumber(
            phoneNumber: toNumericString(_phoneController.text),
          ),
        );
      }
    }

    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (BuildContext context, state) {
        print('state state state ');
        print(state);
        //*[Start] AnonSession
        if (state is AnonRegistrationSucces) {
          BlocProvider.of<SessionBloc>(context).add(
            LogIn(),
          );
        }
        if (state is AnonRegistrationFailrule) {
          const snackBar = SnackBar(
            content: Text(
                'Произошла какая-то ошибка c анонимным входом, попробуйте позже'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        //*[END] AnonSession

        //*[Start] PhoneNumberSession
        if (state is VerifyPhoneNumberSucces) {
          Navigator.pushNamed(
            context,
            VerifyOTPScreen.routeName,
            arguments: state.verificationIds,
          );
        }
        if (state is VerifyPhoneNumberFailure) {
          print('state VerifyPhoneNumberFailure');
          const snackBar = SnackBar(
            content: Text(
                'Произошла какая-то ошибка во время проверки вашего номера телефона, попробуйте ещё раз'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        //*[END] PhoneNumberSession
      },
      child: Scaffold(
        body: BackgroundPattern(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
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
                    Form(
                      key: _formKey,
                      child: Builder(
                        builder: (context) {
                          String? _errorText;
                          return StatefulBuilder(
                            builder: (BuildContext context, setState) {
                              return CircleTextField(
                                controller: _phoneController,
                                inputFormatters: [PhoneInputFormatter()],
                                errorText: _errorText,
                                validator: (value) {
                                  int length = toNumericString(value).length;
                                  bool isError = false;
                                  if (length < 8) {
                                    _errorText =
                                        'Укажите полный номер телефона';
                                    isError = true;
                                  }
                                  if (value == null || value.isEmpty) {
                                    _errorText = 'Поле не может быть пустым';
                                    isError = true;
                                  }
                                  if (!isError) {
                                    _errorText = null;
                                  }
                                  // return _errorText;
                                  setState(() {});
                                  return _errorText;
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    ContinueButton(
                      onPress: verifyPhoneNumber,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                      onPressed: anonAuth,
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
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
