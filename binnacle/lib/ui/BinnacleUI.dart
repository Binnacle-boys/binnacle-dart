import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'compass/BinnacleBase.dart';
import 'package:sos/model/Wind.dart';
import 'package:sos/model/Boat.dart';

class BinnacleUI extends StatelessWidget {
  BinnacleUI(
      {Key key, this.currentBoat, this.idealBoat, this.wind, this.direction})
      : super(key: key);

  final Wind wind;
  final Boat currentBoat;
  final Boat idealBoat;
  final double direction;

  Widget build(BuildContext context) {
    return new Transform.rotate(
        angle: ((direction ?? 0) * (math.pi / 180) * -1),
        child: new BinnacleBase(context));
  }
}
