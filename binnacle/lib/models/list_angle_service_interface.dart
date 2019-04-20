import 'dart:async';
import './list_angle_model.dart';

abstract class IListAngleService {
  StreamController<ListAngleModel> get listAngleStream;
  dispose();
}


