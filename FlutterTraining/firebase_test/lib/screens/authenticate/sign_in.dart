import 'package:firebase_test/models/userData.dart';
import 'package:firebase_test/services/auth.dart';
import 'package:firebase_test/shared/constants.dart';
import 'package:firebase_test/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toogleView;

  SignIn({required this.toogleView, Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  late String email, password;
  String? error;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              title: Text('Sign in screen'),
              actions: <Widget>[
                TextButton.icon(
                    onPressed: () {
                      widget.toogleView();
                    },
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(labelText: 'Email'),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please enter an email';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: 'Password'),
                          validator: (val) {
                            if (val == null || val.length <= 6) {
                              return 'Please enter an password 6+ chars long';
                            }
                            return null;
                          },
                          obscureText: true,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          error ?? '',
                          style: TextStyle(color: Colors.red[600]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.brown[400]),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    UserData? result =
                                        await _auth.signInWithEmailAndPassword(
                                            email, password);
                                    if (result == null) {
                                      setState(() {
                                        loading = false;
                                        error =
                                            'could not sign in with those credentials';
                                      });
                                    }
                                  }
                                },
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(color: Colors.white),
                                )),
                            TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.brown[400]),
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  UserData? result = await _auth.signInAnon();
                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error = 'could not sign in';
                                    });
                                  }
                                },
                                child: const Text('Anon auth',
                                    style: TextStyle(color: Colors.white))),
                            TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.brown[400]),
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  UserData? result = await _auth.signInAnon();
                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error = 'could not sign in';
                                    });
                                  }
                                },
                                child: const Text('Google auth',
                                    style: TextStyle(color: Colors.white))),
                          ],
                        )
                      ],
                    ))),
          );
  }
}
