import 'package:flutter/material.dart';
import 'package:memory_box/shared/backgoundPattern.dart';
import 'package:memory_box/shared/continueButton.dart';

class NewUserScreen extends StatelessWidget {
  NewUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundPattern(
        child: Align(
          alignment: Alignment.center,
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Column(
              children: [
                Container(
                  height: 330,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'MemoryBox',
                          style: TextStyle(
                            letterSpacing: 6,
                            fontSize: 48,
                            fontFamily: 'TTNorms',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Твой голос всегда рядом',
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2,
                          color: Colors.white,
                          fontFamily: 'TTNorms',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
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
                        print('eq');
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
