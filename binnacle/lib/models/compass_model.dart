import 'model.dart';

class CompassModel extends Model {
  double _direction;

  CompassModel({double direction}) {
    this._direction = direction;
  }

  double get direction => _direction;
}
