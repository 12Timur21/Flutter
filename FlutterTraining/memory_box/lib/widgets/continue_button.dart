import 'package:flutter/material.dart';

class ContinueButton extends StatefulWidget {
  ContinueButton({
    required this.onPress,
    Key? key,
  }) : super(key: key);

  VoidCallback onPress;
  @override
  _ContinueButtonState createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<ContinueButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.onPress,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
          ),
          primary: const Color.fromRGBO(241, 180, 136, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Text(
          'Продолжить',
          style: TextStyle(
            fontFamily: 'TTNorms',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            letterSpacing: 0.1,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
