import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_test/services/auth.dart';
import 'package:firebase_test/services/dataBaseService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'brew_list.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>.value(
      initialData: null,
      value: DatabaseService().brews,
      child: Scaffold(
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
        body: BrewList(),
      ),
    );
  }
}
