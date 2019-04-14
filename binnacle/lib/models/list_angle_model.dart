import 'dart:math';

import 'package:sensors/sensors.dart';

class ListAngleModel extends Object {
  double _angle;

  ListAngleModel({double angle}) {
    this._angle = angle;
  }
  ListAngleModel.fromAccelerometerEvent(
      {AccelerometerEvent accelerometerEvent}) {
    double radians = atan2(accelerometerEvent.x, accelerometerEvent.y);
    this._angle = (radians * 180) / pi;
  }

  double get angle => _angle;
}
