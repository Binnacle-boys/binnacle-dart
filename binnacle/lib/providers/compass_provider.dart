import 'dart:async';
import '../models/compass_model.dart';


class CompassProvider {
  ICompassService _compassService;
  

  CompassProvider({ICompassService compassService}){
    this._compassService = compassService;
    print("COMPASS PROVIDER: "+_compassService.compassStream.toString());
  }

  StreamController<CompassModel> get compass => _compassService.compassStream;

}
abstract class ICompassService {
  StreamController <CompassModel> get compassStream;

}

