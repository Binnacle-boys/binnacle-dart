import 'dart:async';
import '../models/compass_model.dart';
import '../models/compass_service_interface.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../models/service_data.dart';

class CompassService extends ICompassService {
  
  StreamController<CompassModel> _compassStream = StreamController();
  final ServiceData _serviceData = ServiceData('compass', 'compass service');


  CompassService() {
    print('Initializing Compass Service');
    FlutterCompass.events.listen((data) => print(data.toString()));
    _compassStream.addStream(FlutterCompass.events.map((double d) => new CompassModel(direction: d)));
    ; // Do I need to listen here?
  }
  StreamController<CompassModel> get compassStream => _compassStream;
  ServiceData get serviceData => _serviceData;

}