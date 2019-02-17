import 'package:geolocator/geolocator.dart';
import 'dart:async';

import '../DataModel.dart';



/// This is a stub until we work on integrating with the algorithm
class IdealBoat extends Boat {
  /// Uses actual data to base the algorithm on
  Boat _actualBoat; // ignore: unused_field
  Wind _wind; // ignore: unused_field

  /// The position of the boom measured in degrees. This angle will always
  /// be with in a range of [90, 270] degrees since the boom should not rotate
  /// all the way around. Relative to the sailboat.
  Stream<double> _boomAngle;
  Stream<double> get boomAngle => _boomAngle;

  /// Position of the boat which includes, course heading,
  /// ground speed, and location (lat/long).
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

  IdealBoat(this._actualBoat, this._wind);
}
