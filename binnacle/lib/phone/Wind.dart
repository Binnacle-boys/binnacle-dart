import '../DataModel.dart';

class PhoneWind extends Wind {
  /// Current speed of the wind in current location in miles per hour.
  double _speed;
  double get speed => _speed;

  /// Current direction of the wind in degrees (where 0 = North, 90 = East).
  double _direction;
  double get direction => _direction;

  /// DateTime when these values were last updated.
  DateTime _lastUpdate;
  DateTime get lastUpdate => _lastUpdate;
}