import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'ArrowPainter.dart';

class WindDirectionUI extends StatelessWidget {
  WindDirectionUI({Key key, this.heading}) : super(key: key);

  final double heading;
  final double radius = 75.0;
  final Color color = Colors.lightBlue;

  Widget build(BuildContext context) {
    return new Transform.rotate(
        angle: ((heading ?? 0) * (math.pi / 180) * -1),
        origin: Offset(radius * math.cos((heading ?? 0) * (math.pi / 180)),
            radius * math.sin(heading ?? 0) * (math.pi / 180)),
        child: CustomPaint(
            painter: ArrowPainter(color: color, percentChange: 0.5)));
  }
}
