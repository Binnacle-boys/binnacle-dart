import 'package:flutter/material.dart';
import 'dart:math';

import 'package:sos/utils/Math.dart';
import 'ArrowPainter.dart';

class WindDirectionUI extends StatelessWidget {
  WindDirectionUI({Key key, this.heading}) : super(key: key);

  // There's an issue with the compass stack. The sizes are different for
  // the different pieces on the stack, thus rotation ends up coming out funky.
  // To get around this I found a good estimate for where 360 degrees is
  // and normalize our value to work around that.
  final double MAGIC_CONSTANT_FOR_ROTATION = 355.3;

  final double heading;
  final double radius = 100;
  final Color color = Colors.lightBlue;

  Widget build(BuildContext context) {
//    return CustomPaint(painter: ArrowPainter(color: color, percentChange: 0.5));
    return Transform.rotate(
        angle: degreesToRadians(
            ((heading ?? 0) / 360) * MAGIC_CONSTANT_FOR_ROTATION),
        child: new Align(
            alignment: Alignment.topCenter,
            child: CustomPaint(
                painter: ArrowPainter(color: color, percentChange: 0.5))));
//    return new RotationTransition(
//        turns: new AlwaysStoppedAnimation(300),
//        child: CustomPaint(
//            painter: ArrowPainter(color: color, percentChange: 0.5)));
  }
}
