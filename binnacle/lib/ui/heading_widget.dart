import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sos/models/ideal_heading_model.dart';
import 'package:sos/ui/global_theme.dart';
import 'package:sos/bloc.dart';
import 'package:sos/providers/app_provider.dart';

class HeadingUI extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return new Container(alignment: Alignment.center, child: CustomPaint(painter: HeadingArrowPainter(superContext: context)));
  }
}

class HeadingArrowPainter extends CustomPainter {
  Color lineColor;

  double width = 4;
  BuildContext superContext;
  var w, h;

  HeadingArrowPainter({this.superContext});

  @override
  void paint(Canvas canvas, Size size) {
    Paint complete = new Paint()
      ..color = GlobalTheme().primaryColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Path path = new Path();
    w = superContext.size.width;
    h = superContext.size.height;
    path.moveTo(0, -130);
    path.lineTo(0, 140);
    path.addPolygon([Offset(3, -130), Offset(0, -135), Offset(-3, -130)], true);
    path.close();
    canvas.drawPath(path, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}