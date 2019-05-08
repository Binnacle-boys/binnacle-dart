class WindModel {
  double _speed;
  double _deg;

  WindModel(speed, deg) {
    this._speed = speed;
    // TODO change back to deg
    this._deg = deg;
  }

  double get speed => _speed;
  double get deg => _deg;
}
