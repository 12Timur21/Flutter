import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RecorderButtonWithIcon extends StatelessWidget {
  const RecorderButtonWithIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: 46,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(241, 180, 136, 1),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 3),
          child: SvgPicture.asset(
            'assets/icons/Voice.svg',
            height: 28,
          ),
        ),
      ),
    );
  }
}
