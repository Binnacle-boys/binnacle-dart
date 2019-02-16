import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'phone/Boat.dart';
import 'phone/Wind.dart';
import 'algorithm/Boat.dart';

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
      Wind phoneWind = new PhoneWind();
      Boat idealBoat = new IdealBoat(phoneBoat, phoneWind);
      return DataModel._internal(phoneBoat, idealBoat, phoneWind);
    } else {
      throw new Exception("Other DataModels not implemented");
    }
  }

  DataModel._internal(this.currentBoat, this.idealBoat, this.wind);
}

/// Interface for the data collected from a sailboat. Implemented for both
/// the live sailboat and a mocked "ideal" sailboat (generated from algorithm).
abstract class Boat {
  /// The position of the boom measured in degrees. This angle will always
  /// be with in a range of [90, 270] degrees since the boom should not rotate
  /// all the way around. Relative to the sailboat.
  Stream<double> _boomAngle;
  Stream<double> get boomAngle => _boomAngle;

  /// Position of the boat which includes, course heading,
  /// ground speed, and location (lat/long).
  // Position stream, for listening on the positions values
  Stream<Position> _positionStream;
  Stream<Position> get positionStream => _positionStream;

  /// Compass heading which differs from the course heading. Determined magnetically,
  /// vs current course. This important to have two differing heading
  /// components to distinguish boats direction vs movement direction 
  /// which could include currents.
  Stream<double> _compassHeading;
  Stream<double> get compassHeading => _compassHeading;

  /// Angle of list, the angle that the boat is in the water. 0 means the boat
  /// is completely flat, where 180 means it's capsized perfectly.
  Stream<double> _listAngle;
  Stream<double> get listAngle => _listAngle;

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