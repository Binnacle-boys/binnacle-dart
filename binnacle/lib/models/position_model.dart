class PositionModel extends Object{
  double _lat;
  double _lon;
  double _speed;

  PositionModel({ double lat, double lon, double speed}){
    this._lat = lat;
    this._lon = lon;
    this._speed = speed;
  }

  double get lat => _lat;
  double get lon => _lon;
  double get speed => _speed;
}