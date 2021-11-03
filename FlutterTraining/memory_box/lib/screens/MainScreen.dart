import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/shared/backgoundPattern.dart';
import 'package:flutter/services.dart';
import 'package:memory_box/shared/bottomNavigationBar.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundPattern(
        child: Container(),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
