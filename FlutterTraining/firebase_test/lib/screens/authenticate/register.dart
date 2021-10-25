import 'package:firebase_test/models/userData.dart';
import 'package:firebase_test/services/auth.dart';
import 'package:firebase_test/shared/constants.dart';
import 'package:firebase_test/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toogleView;
  Register({required this.toogleView, Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
              elevation: 0.0,
              title: Text('Register screen'),
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
                      "Sign in",
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
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.brown[400]),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                UserData? result =
                                    await _auth.registerWithEmailAndPasswor(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                    loading = false;
                                    error = 'Please supply a valid email';
                                  });
                                }
                              }
                            },
                            child: Text('Register',
                                style: TextStyle(color: Colors.white))),
                        SizedBox(height: 12.0),
                        Text(
                          error ?? '',
                          style: TextStyle(color: Colors.red[600]),
                        )
                      ],
                    ))),
          );
  }
}
