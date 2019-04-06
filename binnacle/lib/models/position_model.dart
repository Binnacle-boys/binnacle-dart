class PositionModel extends Object{
  double _lat;
  double _lon;

  PositionModel(this._lat, this._lon);

  double get lat => _lat;
  double get lon => _lon;
}