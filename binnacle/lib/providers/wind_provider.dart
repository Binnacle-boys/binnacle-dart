import 'dart:async';
import 'package:rxdart/rxdart.dart';


class WindProvider {

    IWindService _windService;
    
    WindProvider({IWindService windService}){
      this._windService = windService;

    }
    StreamController get wind => _windService.windStream;


}
abstract class IWindService {
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