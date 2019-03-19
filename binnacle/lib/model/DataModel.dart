import 'phone/PhoneBoat.dart';
import 'phone/PhoneWind.dart';
import 'Wind.dart';
import 'Boat.dart';
import '../algorithm/Boat.dart';

enum SensorType {
  phone,
  bluetooth
}

/// Data that sailing UI needs. Can be implemented for both a sensor package
/// and a standalone UI.

abstract class DataModelBase {
  Boat currentBoat;
  Boat idealBoat;
  Wind wind;
}

class DataModel extends DataModelBase{
//  Boat currentBoat;
//  Boat idealBoat;
//  Wind wind;

  factory DataModel(SensorType type) {
    if (type == SensorType.phone) {
      Boat phoneBoat = new PhoneBoat();
      Wind phoneWind = new PhoneWind();
      Boat idealBoat = new IdealBoat(phoneBoat, phoneWind);
      return DataModel._internal(phoneBoat, idealBoat, phoneWind);
    } else {
      throw new Exception("Other DataModels not implemented");
    }
  }

  DataModel._internal(currentBoat, idealBoat, wind){
    this.currentBoat = currentBoat;
    this.idealBoat = idealBoat;
    this.wind = wind;
  }
}