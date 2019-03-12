import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../Boat.dart';
import 'package:sensors/sensors.dart';
import 'dart:async';
import 'package:sos/utils/Math.dart';

/// Interface for the data collected from a sailboat. Implemented for both
/// the live sailboat and a mocked "ideal" sailboat (generated from algorithm).
class PhoneBoat extends Boat {
  static final PhoneBoat instance = new PhoneBoat._internal();
  Geolocator geolocator;

  factory PhoneBoat() {
    return instance;
  }

  PhoneBoat._internal(){
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
    listAngle.addStream(accelerometerToListAngle(accelerometerEvents));
  }

}