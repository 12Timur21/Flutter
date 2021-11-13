import 'package:flutter/material.dart';
import 'package:memory_box/models/userModel.dart';
import 'package:memory_box/screens/Registration/newUserScreen.dart';
import 'package:memory_box/screens/mainPage.dart';
import 'package:memory_box/screens/Registration/registration.dart';
import 'package:memory_box/screens/permanentUserScreen.dart';
import 'package:provider/provider.dart';

class Root extends StatefulWidget {
  static const routeName = 'RootPage';
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserModel?>(context);

    if (user == null) {
      return NewUserScreen();
    } else {
      return PermanentsUserScreen();
    }
  }
}
