import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/models/userData.dart';
import 'package:firebase_test/models/userData.dart';
import 'package:firebase_test/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserData? user = Provider.of<UserData?>(context);

    if (user == 0) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
