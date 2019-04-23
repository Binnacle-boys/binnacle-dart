import 'dart:math';

import 'package:sensors/sensors.dart';

class ListAngleModel {
  double _angle;

  ListAngleModel({double angle}) {
    this._angle = angle;
  }
  ListAngleModel.fromAccelerometerEvent(
      {AccelerometerEvent accelerometerEvent}) {
    double radians = atan2(accelerometerEvent.x, accelerometerEvent.y);
    this._angle = radians;
  }

  double get angle => _angle;
}
