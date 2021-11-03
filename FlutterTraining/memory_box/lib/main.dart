import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/screens/mainScreen.dart';
import 'screens/wrapper.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromRGBO(246, 246, 246, 1),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Box',
      initialRoute: '/wrapper',
      routes: <String, WidgetBuilder>{
        '/wrapper': (BuildContext context) => Wrapper(),
        '/mainScreen': (BuildContext context) => MainScreen(),
      },
      home: Container(
        color: const Color.fromRGBO(246, 246, 246, 1),
        child: Wrapper(),
      ),
    );
  }
}
