import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/providers/user.dart';
import 'package:provider_test/screens/home.dart';
import 'package:provider_test/screens/settings.dart';

import 'models/darkModeModel.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => DarkModeModel(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<User>(create: (_) => User()),
          Provider<Settings>(create: (_) => Settings()),
        ],
        child: MaterialApp(
          routes: <String, WidgetBuilder>{
            '/': (context) => Home(),
            '/settings': (context) => Settings()
          },
        ));
  }
}
