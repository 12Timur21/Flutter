import 'package:firebase_test/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        title: Text('Brew Crew'),
        backgroundColor: Colors.lime[300],
        actions: [
          ElevatedButton(
            onPressed: () async {
              await _auth.signOut();
            },
            child: Text('Sign out'),
          ),
        ],
      ),
      body: Container(
        child: Text('home'),
      ),
    );
  }
}
