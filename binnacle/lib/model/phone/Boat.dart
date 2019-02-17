import 'package:geolocator/geolocator.dart';
import '../Boat.dart';

/// Interface for the data collected from a sailboat. Implemented for both
/// the live sailboat and a mocked "ideal" sailboat (generated from algorithm).
class PhoneBoat extends Boat {
  Geolocator geolocator;

  PhoneBoat() {
    geolocator = Geolocator();
    int distanceFilter = 10;
    LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: distanceFilter);
    positionStream = geolocator.getPositionStream(locationOptions);
    print("PhoneBoat()");
  }
}