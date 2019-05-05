import 'dart:async';
import './compass_model.dart';

abstract class ICompassService {
  StreamController<CompassModel> get compassStream;
  dispose();
}
