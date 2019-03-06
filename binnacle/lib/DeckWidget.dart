import 'package:flutter/material.dart';
class DeckWidget extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = Colors.blueGrey;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 5.0;
    // var bow = Offset(size.width / 2, 10);
    var path = Path();
    var HorizontalMargin = 5.0;
    var VerticalMagin = 100.0;

    path.moveTo(size.width/2, 10);
    path.quadraticBezierTo(0, 100, HorizontalMargin, size.height - VerticalMagin);
    path.quadraticBezierTo(size.width/2, size.height - VerticalMagin/2, size.width -HorizontalMargin, size.height -VerticalMagin);
    path.quadraticBezierTo(size.width, 100, size.width/2, 10) ;

    canvas.drawPath(path, paint);

    // draw the circle on centre of canvas having radius 75.0
    // canvas.drawCircle(bow, 100.0, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}