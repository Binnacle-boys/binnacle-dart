import 'package:geolocator/geolocator.dart';
import 'dart:async';

/// Interface for the data collected from a sailboat. Implemented for both
/// the live sailboat and a mocked "ideal" sailboat (generated from algorithm).
abstract class Boat {
  /// The position of the boom measured in degrees. This angle will always
  /// be with in a range of [90, 270] degrees since the boom should not rotate
  /// all the way around. Relative to the sailboat.
  StreamController<double> boomAngle;

  /// Position of the boat which includes, course heading,
  /// ground speed, and location (lat/long).
  /// Position stream, for listening on the positions values
  Position position;

  /// Compass heading which differs from the course heading. Determined magnetically,
  /// vs current course. This important to have two differing heading
  /// components to distinguish boats direction vs movement direction
  /// which could include currents.
  StreamController<double> compassHeading;

  /// Angle of list, the angle that the boat is in the water. 0 means the boat
  /// is completely flat, where 180 means it's capsized perfectly.
  StreamController<double> listAngle;

  /// DateTime when these values were last updated.
  DateTime lastUpdate;
}