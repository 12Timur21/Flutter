import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/models/userModel.dart';
import 'package:memory_box/routes/app_router.dart';
import 'package:memory_box/screens/mainPage.dart';
import 'package:memory_box/screens/registration.dart';
import 'package:memory_box/screens/wrapper.dart';
import 'package:memory_box/services/authService.dart';
import 'package:provider/provider.dart';
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
    return StreamProvider<UserModel?>.value(
      value: AuthService.instance.user,
      initialData: null,
      catchError: (_, __) => null,
      child: MaterialApp(
          title: 'Memory Box',
          // initialRoute: '/',
          onGenerateRoute: AppRouter.generateRoute,
          home: Wrapper()),
    );
  }
}
