import 'dart:async';
import '../models/compass_model.dart';
import '../models/compass_service_interface.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../models/service_data.dart';
import './service_wrapper_interface.dart';

class CompassService extends ICompassService {
  
  StreamController<CompassModel> _compassStream = StreamController();
  StreamSubscription _subscription;


  CompassService() {
    _subscription = FlutterCompass.events.listen((data) => _compassStream.sink.add(CompassModel(direction: data)));

  }
  dispose() async {
    await _subscription.pause();
    
    await _compassStream.close();

  }
  StreamController<CompassModel> get compassStream => _compassStream;

}

class CompassServiceWrapper implements ServiceWrapper{
  final ServiceData _serviceData = ServiceData('compass', 'flutter compass', 1);
  final bool _default = true;

  CompassServiceWrapper();

  get service =>  CompassService();
  ServiceData get serviceData => this._serviceData;
  bool get isDefault => this._default;

}