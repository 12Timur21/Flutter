import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/models/userModel.dart';
import 'package:memory_box/routes/app_router.dart';
import 'package:memory_box/screens/mainPage.dart';
import 'package:memory_box/screens/Registration/registration.dart';
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
      child: const MaterialApp(
        title: 'Memory Box',
        initialRoute: Root.routeName,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
