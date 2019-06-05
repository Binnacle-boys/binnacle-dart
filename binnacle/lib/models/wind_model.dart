class WindModel {
  double _speed;
  double _deg;

  WindModel(double speed, double deg) {
    this._speed = speed;
    // TODO change back to deg
    this._deg = deg;
  }

  double get speed => _speed;
  double get deg => _deg;
}
