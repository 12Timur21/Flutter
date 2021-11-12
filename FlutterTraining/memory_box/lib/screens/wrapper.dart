import 'package:flutter/material.dart';
import 'package:memory_box/models/userModel.dart';
import 'package:memory_box/screens/mainPage.dart';
import 'package:memory_box/screens/registration.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserModel?>(context);

    if (user == null) {
      return Registration();
    } else {
      return MainPage();
    }
  }
}
