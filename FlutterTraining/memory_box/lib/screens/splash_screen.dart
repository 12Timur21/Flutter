import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromRGBO(128, 119, 228, 1),
            Color.fromRGBO(195, 132, 200, 1),
            Color.fromRGBO(255, 144, 175, 1),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'MemoryBox',
            style: TextStyle(
              fontFamily: 'TTNorms',
              fontWeight: FontWeight.bold,
              fontSize: 50,
              letterSpacing: 0.6,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          SvgPicture.asset(
            'assets/icons/Logo.svg',
          ),
        ],
      ),
    );
  }
}
