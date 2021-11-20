import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/models/userModel.dart';
import 'package:memory_box/routes/app_router.dart';
import 'package:memory_box/screens/root.dart';
import 'package:memory_box/services/authService.dart';
import 'package:memory_box/settings/initialSettings.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  InitialSettings();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthService.instance.user,
      initialData: null,
      catchError: (_, __) => null,
      child: MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        title: 'Memory Box',
        initialRoute: Root.routeName,
        onGenerateRoute: AppRouter.generateRoute,
        theme: ThemeData(
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontFamily: 'TTNorms',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
