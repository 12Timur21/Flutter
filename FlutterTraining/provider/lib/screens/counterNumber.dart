// ignore_for_file: file_names

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider_test/providers/click.dart';

class CounterNumber extends StatelessWidget {
  const CounterNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int _counter = Provider.of<int>(context);
    final Click click = Provider.of<Click>(context);

    return Text(
      click.clickCount.toString(),
      style: TextStyle(
        fontSize: 40,
        color: Colors.white,
      ),
    );
  }
}
