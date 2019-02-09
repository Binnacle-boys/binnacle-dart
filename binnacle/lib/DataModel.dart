/// Data that sailing UI needs. Can be implemented for both a sensor package
/// and a standalone UI.
abstract class DataModel {
  Boat _currentBoat;
  Boat get currentBoat => _currentBoat;

  Boat _idealBoat;
  Boat get idealBoat => _idealBoat;

  Wind _wind;
  Wind get wind => _wind;
}

/// Interface for the data collected from a sailboat. Implemented for both
/// the live sailboat and a mocked "ideal" sailboat (generated from algorithm).
abstract class Boat {
  /// The position of the boom measured in degrees. This angle will always
  /// be with in a range of [90, 270] degrees since the boom should not rotate
  /// all the way around. Relative to the sailboat.
  double _boomAngle = -1;
  double get boomAngle => _boomAngle;

  /// Speed of the boat in miles per hour.
  double _speed = -1;
  double get speed => _speed;

  /// Heading of the boat in degrees. Compass direction (North = 0, East = 90)
  double _headingAngle = -1;
  double get headingAngle => _headingAngle;

  /// Angle of list, the angle that the boat is in the water. 0 means the boat
  /// is completely flat, where 180 means it's capsized perfectly.
  double _listAngle = -1;
  double get listAngle => _listAngle;

  /// DateTime when these values were last updated.
  DateTime _lastUpdate;
  DateTime get lastUpdate => _lastUpdate;
}

abstract class Wind {
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