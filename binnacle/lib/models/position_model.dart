import 'package:google_maps_flutter/google_maps_flutter.dart';

class PositionModel extends Object {
  double _lat;
  double _lon;
  double _speed;

  PositionModel({double lat, double lon, double speed}) {
    this._lat = lat;
    this._lon = lon;
    // 1.94384 is mps to knots
    // TODO When does the library throw a null? Field testing required
    this._speed = (speed == -1.0 || speed == null) ? 0.0 : (speed * 1.94384);
  }
  LatLng get latlng => new LatLng(_lat, _lon);
  double get lat => _lat;
  double get lon => _lon;
  double get speed => _speed;
}
