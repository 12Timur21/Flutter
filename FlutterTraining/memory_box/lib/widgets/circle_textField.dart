import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CircleTextField extends StatelessWidget {
  const CircleTextField({
    required this.controller,
    this.inputFormatters,
    this.editable = true,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(41),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.11),
            blurRadius: 7,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        enabled: editable,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.phone,
        inputFormatters: inputFormatters,
        style: const TextStyle(
          fontFamily: 'TTNorms',
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
