import '../model/Boat.dart';
import '../model/Wind.dart';



/// This is a stub until we work on integrating with the algorithm
class IdealBoat extends Boat {
  /// Uses actual data to base the algorithm on
  Boat _actualBoat; // ignore: unused_field
  Wind _wind; // ignore: unused_field

  IdealBoat(this._actualBoat, this._wind);
}
