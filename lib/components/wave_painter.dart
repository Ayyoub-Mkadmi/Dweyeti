import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue[700]!
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(0, size.height * 0.9)
          ..quadraticBezierTo(
            size.width * 0.25,
            size.height * 0.7,
            size.width * 0.5,
            size.height * 1,
          )
          ..quadraticBezierTo(
            size.width * 0.75,
            size.height * 1.2,
            size.width * 1,
            size.height * 0.9,
          )
          ..lineTo(size.width, 0)
          ..lineTo(0, 0)
          ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
