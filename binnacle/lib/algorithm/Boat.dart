import '../model/Boat.dart';
import '../model/Wind.dart';

/// This is a stub until we work on integrating with the algorithm
class IdealBoat extends Boat {
  /// Uses actual data to base the algorithm on
  Boat _actualBoat;
  Wind _wind;

  IdealBoat(this._actualBoat, this._wind);
}
