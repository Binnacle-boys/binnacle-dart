import 'dart:async';
import 'weather_provider.dart';
import '../models/position_model.dart';
import 'package:rxdart/rxdart.dart';


class WindProvider {

    final _weatherProvider = WeatherProvider();
    BehaviorSubject<PositionModel> _positionStream;
    
    WindProvider(BehaviorSubject<PositionModel> position){
      this._positionStream = position;
      _weatherProvider.init(this._positionStream.value);
    }
    StreamController get wind => _weatherProvider.windStream;


}
abstract class IWind {
  StreamController <WindModel> get windStream;

}

class WindModel {
  double _speed;
  double _deg;

  WindModel(speed, deg) {
    this._speed = speed;
    this._deg = deg;
  }

  double get speed => _speed;
  double get deg => _deg;

}