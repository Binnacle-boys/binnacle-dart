import 'dart:async';
import 'package:geolocator/geolocator.dart';

abstract class Wind {
  /// Current speed of the wind in current location in miles per hour.
  StreamController<double> speed = StreamController<double>();

  /// Current direction of the wind in degrees (where 0 = North, 90 = East).
  StreamController<double> direction = StreamController<double>();

  /// DateTime when these values were last updated.
  DateTime lastUpdate;

  void setPositionStream(Stream<Position> locationStream);
}