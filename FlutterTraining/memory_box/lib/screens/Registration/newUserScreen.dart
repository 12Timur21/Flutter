import 'package:flutter/material.dart';
import 'package:memory_box/screens/Registration/registration.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/continueButton.dart';
import 'package:memory_box/widgets/textLogo.dart';

class NewUserScreen extends StatelessWidget {
  const NewUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void navigateToRegistration() {
      Navigator.pushReplacementNamed(
        context,
        Registration.routeName,
      );
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
