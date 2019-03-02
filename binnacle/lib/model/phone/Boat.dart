import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../Boat.dart';
import 'package:sensors/sensors.dart';
import 'dart:async';
import 'dart:math';

/// Interface for the data collected from a sailboat. Implemented for both
/// the live sailboat and a mocked "ideal" sailboat (generated from algorithm).
class PhoneBoat extends Boat {
  Geolocator geolocator;
  AccelerometerEvent test;
  
  PhoneBoat() {
    geolocator = Geolocator();
    int distanceFilter = 10;
    LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: distanceFilter);
    positionStream = geolocator.getPositionStream(locationOptions).asBroadcastStream();

    // Setting up the accelerometer stream
    initListAngleStream();

    // Setting up compass stream
    compassHeading = StreamController<double>();
    compassHeading.addStream(FlutterCompass.events);
    print("PhoneBoat()");
  }

  void initListAngleStream() {
    listAngle = new StreamController<double>();
    listAngle.addStream(accelerometerToZRotate(accelerometerEvents));
  }

  // Converting acclerometer stream into a listAngle stream
  // listAngle/phoneRoll
  Stream<double> accelerometerToZRotate(Stream<AccelerometerEvent> sensorStream) async* {
    double zRotation;
    await for (var event in sensorStream) {
      // Conversion for getting the z rotation when potrait
      // from the accelerometer which will be the 
      // phone's way of calculating the
      // angle of list
      zRotation =  atan2(event.x, event.y);
      yield zRotation;
    }
  }

}