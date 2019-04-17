import 'dart:async';
import '../models/compass_model.dart';
import '../models/compass_service_interface.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../models/service_data.dart';

class CompassService extends ICompassService {
  
  StreamController<CompassModel> _compassStream = StreamController();
  final ServiceData _serviceData = ServiceData('compass', 'compass service');
  StreamSubscription _subscription;


  CompassService() {
    print('Initializing Compass Service');
    _subscription = FlutterCompass.events.listen((data) => _compassStream.sink.add(CompassModel(direction: data)));
    // _compassStream.addStream(FlutterCompass.events.map((double d) => new CompassModel(direction: d)));
    ; // Do I need to listen here?
  }
  dispose() async {
    await _subscription.pause();
    
    await _compassStream.close();

    // await _compassStream.close();

  }
  StreamController<CompassModel> get compassStream => _compassStream;
  ServiceData get serviceData => _serviceData;

}