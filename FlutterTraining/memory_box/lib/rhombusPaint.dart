import 'package:flutter/material.dart';

class CustomSliderThumbRhombus extends SliderComponentShape {
  double thumbRadius = 20;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    double? value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 48, 66, 80)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Size size = Size(10, 10);

    Path path0 = Path();
    path0.moveTo(0, size.height * 0.5001000);
    path0.quadraticBezierTo(size.width * 0.1638000, size.height * 0.2582000,
        size.width * 0.5000000, size.height * 0.2500000);
    path0.quadraticBezierTo(size.width * 0.8481000, size.height * 0.2590000,
        size.width, size.height * 0.5000000);
    path0.quadraticBezierTo(size.width * 0.8477000, size.height * 0.7538000,
        size.width * 0.5000000, size.height * 0.7500000);
    path0.quadraticBezierTo(size.width * 0.1382000, size.height * 0.7459000, 0,
        size.height * 0.5001000);
    path0.close();

    canvas.drawPath(path0, paint0);
  }
}
