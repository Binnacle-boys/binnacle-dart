import 'package:flutter/material.dart';

import 'package:sos/utils/Math.dart';
import 'ArrowPainter.dart';

class CompassHeadingUI extends StatelessWidget {
  CompassHeadingUI({Key key, this.heading, this.color}) : super(key: key);

  // There's an issue with the compass stack. The sizes are different for
  // the different pieces on the stack, thus rotation ends up coming out funky.
  // To get around this I found a good estimate for where 360 degrees is
  // and normalize our value to work around that.
  final double MAGIC_CONSTANT_FOR_ROTATION = 355.3;

  final double radius = 100;

  final double heading;
  final Color color;

  Widget build(BuildContext context) {
    return Transform.rotate(
        angle: degreesToRadians(
            ((heading ?? 0) / 360) * MAGIC_CONSTANT_FOR_ROTATION),
        child: new Align(
            alignment: Alignment.topCenter,
            child: CustomPaint(
                painter: ArrowPainter(color: color, percentChange: 0.5))));
  }
}
