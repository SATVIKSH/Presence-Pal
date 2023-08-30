import 'package:flutter/cupertino.dart';

class WavyIndicator extends CustomPainter {
  WavyIndicator(
      {required this.color, required this.factor, required this.bezier});
  final Color color;
  final double factor;
  final double bezier;
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    var shadowPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    if (factor == 1) {
      var path = Path()
        ..moveTo(0, 0)
        ..lineTo(0, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, 0);
      canvas.drawPath(path, paint);
    } else {
      var shadowPath = Path()
        ..moveTo(0, size.height)
        ..lineTo(0, size.height * (1 - (factor + 0.1)))
        ..quadraticBezierTo(
            (size.width) / 4 + 0.2,
            size.height * (1 - (factor + bezier + 0.1)),
            size.width / 2 + 0.2,
            size.height * (1 - (factor + 0.1)))
        ..lineTo(size.width / 2 + 0.2, size.height * (1 - (factor + 0.1)))
        ..quadraticBezierTo(
            size.width * 3 / 4 + 0.2,
            size.height * (1 - (factor - bezier + 0.1)),
            size.width + 0.2,
            size.height * (1 - (factor + 0.1)))
        ..lineTo(size.width + 0.2, size.height * (1 - (factor)))
        ..lineTo(size.width, size.height);
      canvas.drawPath(shadowPath, shadowPaint);
      var path = Path()
        ..moveTo(0, size.height)
        ..lineTo(0, size.height * (1 - factor))
        ..quadraticBezierTo(
            size.width / 4,
            size.height * (1 - (factor + bezier)),
            size.width / 2,
            size.height * (1 - factor))
        ..lineTo(size.width / 2, size.height * (1 - factor))
        ..quadraticBezierTo(
            size.width * 3 / 4,
            size.height * (1 - (factor - bezier)),
            size.width,
            size.height * (1 - factor))
        ..lineTo(size.width, size.height * (1 - factor))
        ..lineTo(size.width, size.height);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
