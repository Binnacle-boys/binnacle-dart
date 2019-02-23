import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'ArrowPainter.dart';

class WindDirectionUI extends StatelessWidget {
  WindDirectionUI({Key key, this.heading}) : super(key: key);

  final double heading;

  Widget build(BuildContext context) {
    return new Transform.rotate(
        angle: ((heading ?? 0) * (math.pi / 180) * -1),
        origin: Offset(50.0, 50.0),
        child: CustomPaint(
            painter: ArrowPainter(color: Colors.green, percentChange: 0.5))
//        child: (new ArrowPainter(Color.fromRGBO(255, 255, 255, 0), 10)))
        );
  }
}
