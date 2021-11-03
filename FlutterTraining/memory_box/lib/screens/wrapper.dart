import 'package:flutter/material.dart';
import 'package:memory_box/screens/mainScreen.dart';
import 'package:memory_box/screens/newUserScreen.dart';
import 'package:memory_box/screens/permanentUserScreen.dart';
import 'package:memory_box/screens/registration.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }
}
