import 'phone/Boat.dart';
import 'phone/Wind.dart';
import 'Wind.dart';
import 'Boat.dart';
import '../algorithm/Boat.dart';

enum SensorType {
  phone,
  bluetooth
}

/// Data that sailing UI needs. Can be implemented for both a sensor package
/// and a standalone UI.
class DataModel {
  static final DataModel instance = new DataModel._internal();
  Boat currentBoat;
  Boat idealBoat;
  Wind wind;

  factory DataModel() {
    return instance;
  }

  DataModel._internal(){
    currentBoat = new PhoneBoat();
    wind = new PhoneWind(currentBoat.positionStream);
    idealBoat = new IdealBoat(currentBoat, wind);
  }
}