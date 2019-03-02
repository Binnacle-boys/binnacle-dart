import 'package:geolocator/geolocator.dart';
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
    initListAngleStream();
    print("PhoneBoat()");
  }

  void initListAngleStream() {
    listAngle = new StreamController<double>();
    listAngle.addStream(accelerometerToRoll(accelerometerEvents));
  }

  // Converting acclerometer stream into a listAngle stream
  // listAngle/phoneRoll
  Stream<double> accelerometerToRoll(Stream<AccelerometerEvent> sensorStream) async* {
    double roll;
    await for (var event in sensorStream) {
      // Conversion for getting the roll of the phone
      // which will be the phone's way of calculating the
      // angle of list
      print("Got a sensor change!");
      roll =  atan2(event.y, event.z);
      yield roll;
    }
  }

}