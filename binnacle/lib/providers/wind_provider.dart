import 'dart:async';
import '../models/wind_model.dart';

class WindProvider {

    IWindService _windService;
    
    WindProvider({IWindService windService}){
      this._windService = windService;
    }
    StreamController<WindModel> get wind => _windService.windStream;


}
abstract class IWindService {
  StreamController <WindModel> get windStream;

}

