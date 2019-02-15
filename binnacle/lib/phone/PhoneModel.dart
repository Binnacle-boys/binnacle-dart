import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../DataModel.dart';

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

/// Interface for the data collected from a sailboat. Implemented for both
/// the live sailboat and a mocked "ideal" sailboat (generated from algorithm).
class PhoneBoat extends Boat {
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

  ///
  Geolocator _geolocator;

  PhoneBoat() {
    _geolocator = Geolocator();
    int distanceFilter = 10;
    LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: distanceFilter);
    _positionStream = _geolocator.getPositionStream(locationOptions);
    print("PhoneBoat()");
  }
}

/// This is a stub until we work on integrating with the algorithm
class IdealBoat extends Boat {
  /// Uses actual data to base the algorithm on
  Boat _actualBoat;
  Wind _wind;

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