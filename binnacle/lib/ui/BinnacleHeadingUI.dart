import 'package:flutter/material.dart';

import 'package:sos/utils/Math.dart';
import 'ArrowPainter.dart';

class BinnacleHeadingUI extends StatelessWidget {
  BinnacleHeadingUI({Key key, this.heading, this.color}) : super(key: key);

  final double radius = 100;

  final double heading;
  final Color color;

  Widget build(BuildContext context) {
    return Transform.rotate(
        angle: degreesToRadians((heading ?? 0) / 360),
        child: new Align(
            alignment: Alignment.topCenter,
            child: CustomPaint(
                painter: ArrowPainter(color: color, percentChange: 0.5))));
  }
}
