import 'dart:async';
import '../models/position_model.dart';


class PositionProvider {
  IPositionService _positionService;
  

  PositionProvider({IPositionService positionService}){
    this._positionService = positionService;
  }


  StreamController<PositionModel> get position => _positionService.positionStream;

}
abstract class IPositionService {
  StreamController <PositionModel> get positionStream;

}

