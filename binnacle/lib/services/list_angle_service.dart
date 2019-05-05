import 'dart:async';
import 'dart:core';
import 'package:rxdart/rxdart.dart';
import 'package:sos/models/list_angle_model.dart';
import 'package:sos/models/service_data.dart';
import 'package:sos/services/service_wrapper_interface.dart';
import '../models/list_angle_service_interface.dart';

import 'package:sensors/sensors.dart';
import '../enums.dart';

class ListAngleService extends IListAngleService {
  BehaviorSubject<ListAngleModel> _listAngleStream =
      BehaviorSubject(seedValue: ListAngleModel(angle: 0.0));

  ListAngleService() {
    _listAngleStream.addStream(accelerometerEvents.map(
        (AccelerometerEvent ae) =>
            ListAngleModel.fromAccelerometerEvent(accelerometerEvent: ae)));
  }
  StreamController<ListAngleModel> get listAngleStream => _listAngleStream;

  dispose() {
    this._listAngleStream.stream.drain();
    this._listAngleStream = null;
    accelerometerEvents.drain();
  }
}

class ListAngleServiceWrapper implements ServiceWrapper{
  final ServiceData _serviceData = ServiceData(ProviderType.list_angle, 'daniels list angle', 1);
  final bool _default = true;

  ListAngleServiceWrapper();

  get service =>  ListAngleService();
  ServiceData get serviceData => this._serviceData;
  bool get isDefault => this._default;

}