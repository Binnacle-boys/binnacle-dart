import '../DataModel.dart';
import './Boat.dart';
import './Wind.dart';
import '../algorithm/Boat.dart';

/// Data that sailing UI needs. Can be implemented for both a sensor package
/// and a standalone UI.
class PhoneModel extends DataModel {
  Boat _currentBoat;
  Boat get currentBoat => _currentBoat;

  Boat _idealBoat;
  Boat get idealBoat => _idealBoat;

  Wind _wind;
  Wind get wind => _wind;

  PhoneModel() {
    _currentBoat = new PhoneBoat();
    _wind = new PhoneWind();
    _idealBoat = new IdealBoat(_currentBoat, _wind);
  }
}



