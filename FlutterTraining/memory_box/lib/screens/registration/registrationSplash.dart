import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/registration/registration_bloc.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/continueButton.dart';
import 'package:memory_box/widgets/textLogo.dart';

class LoginSpash extends StatelessWidget {
  const LoginSpash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void navigateToRegistration() {
      final _loginBloc = BlocProvider.of<RegistrationBloc>(context);
      _loginBloc.add(LoadLoadingPage());
    }

    return Scaffold(
      body: BackgroundPattern(
        child: Padding(
          // alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: Column(
            children: [
              Container(
                height: 275,
                width: double.infinity,
                alignment: Alignment.center,
                child: const TextLogo(),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                children: <Widget>[
                  const Text(
                    'Привет!',
                    style: TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Мы рады видеть тебя здесь. \n Это приложение поможет записывать \n сказки и держать их в удобном месте не \n заполняя память на телефоне',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ContinueButton(
                    onPress: () {
                      navigateToRegistration();
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
