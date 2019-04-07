import 'dart:async';
import 'weather_provider.dart';


class WindProvider {

    final _weatherProvider = WeatherProvider();
    
    WindProvider(){
      _weatherProvider.init("84.044","121.066");
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