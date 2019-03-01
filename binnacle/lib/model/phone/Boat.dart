import 'package:geolocator/geolocator.dart';
import '../Boat.dart';

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
    print("PhoneBoat()");
  }
}