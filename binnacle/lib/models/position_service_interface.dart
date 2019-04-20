import 'dart:async';
import './position_model.dart';

abstract class IPositionService {
  StreamController<PositionModel> get positionStream;
  dispose();
}