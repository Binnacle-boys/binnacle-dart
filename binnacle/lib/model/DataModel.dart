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
  Boat currentBoat;
  Boat idealBoat;
  Wind wind;

  factory DataModel(SensorType type) {
    if (type == SensorType.phone) {
      Boat phoneBoat = new PhoneBoat();
      Wind phoneWind = new PhoneWind(phoneBoat.positionStream);
      Boat idealBoat = new IdealBoat(phoneBoat, phoneWind);
      return DataModel._internal(phoneBoat, idealBoat, phoneWind);
    } else {
      throw new Exception("Other DataModels not implemented");
    }
  }

  DataModel._internal(this.currentBoat, this.idealBoat, this.wind);
}