import 'dart:async';
import './service_data.dart';
import './compass_model.dart';


abstract class ICompassService {
  StreamController <CompassModel> get compassStream;
  ServiceData get serviceData;
  dispose();

}

