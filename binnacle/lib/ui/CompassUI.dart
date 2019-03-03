import 'package:flutter/material.dart';
import 'compass/CompassBase.dart';
import 'dart:math' as math;

class CompassUI extends StatelessWidget {
  CompassUI({Key key, this.direction}) : super(key: key);

  final double direction;

  Widget build(BuildContext context) {
    return new Transform.rotate(angle: ((direction ?? 0) * (math.pi / 180) * -1),
             child: new CompassBase());
  
  }
}