import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Box',
      initialRoute: '/wrapper',
      routes: <String, WidgetBuilder>{
        '/wrapper': (BuildContext context) => Wrapper()
      },
      home: Scaffold(
        backgroundColor: Color.fromRGBO(246, 246, 246, 100),
        body: Wrapper(),
      ),
    );
  }
}
