import 'package:firebase_test/models/userData.dart';
import 'package:firebase_test/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in to Brew Crew'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: ElevatedButton(
          child: Text('Sign in anon'),
          onPressed: () async {
            UserData? result = await _auth.signInAnon();
            if (result == 0) {
              print('Error sign in');
            } else {
              print('sign in ${result?.uid}');
            }
          },
        ),
      ),
    );
  }
}
