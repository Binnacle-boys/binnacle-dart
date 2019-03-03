import 'dart:math';
import 'dart:async';
import 'package:sensors/sensors.dart';

double radiansToDegrees(double radians) {
  return radians * 180 / pi;
}

// Converting acclerometer stream into a listAngle stream
  // listAngle/phoneRoll
  Stream<double> accelerometerToListAngle(Stream<AccelerometerEvent> sensorStream) async* {
    double listAngle;
    // Every event in the acclerometer stream convert value to list angle
    await for (var event in sensorStream) {
      // Conversion for getting the z rotation when potrait
      // from the accelerometer which will be the 
      // phone's way of calculating the
      // angle of list
      if (event != null) {
        listAngle =  eventToListAngle(event);
      }
      yield listAngle;
    }
  }

  double eventToListAngle(AccelerometerEvent event) {
    return atan2(event.x, event.y);
  }