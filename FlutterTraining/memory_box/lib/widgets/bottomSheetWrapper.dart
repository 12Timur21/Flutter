import 'package:flutter/material.dart';

class BottomSheetWrapeer extends StatelessWidget {
  const BottomSheetWrapeer({
    required this.child,
    this.height,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 500,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(246, 246, 246, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0.5,
          ),
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 15),
            spreadRadius: 0.5,
          ),
          BoxShadow(
            color: Color.fromRGBO(239, 239, 247, 1),
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: child,
    );
  }
}
