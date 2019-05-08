import 'dart:async';
import './wind_model.dart';

abstract class IWindService {
  StreamController<WindModel> get windStream;
  dispose();
}
