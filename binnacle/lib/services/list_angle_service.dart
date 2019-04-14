import 'dart:async';
import 'package:sos/models/list_angle_model.dart';
import 'package:sos/providers/list_angle_provider.dart';

import 'package:sensors/sensors.dart';
import 'package:flutter_compass/flutter_compass.dart';

class ListAngleService extends IListAngleService {
  StreamController<ListAngleModel> _listAngleStream = StreamController();

  ListAngleService() {
    print('Initializing ListAngle Service');

    _listAngleStream.addStream(accelerometerEvents.take(5).map(
        (AccelerometerEvent ae) =>
            ListAngleModel.fromAccelerometerEvent(accelerometerEvent: ae)));
    ; // Do I need to listen here?
  }
  Stream<ListAngleModel> get listAngleStream => _listAngleStream.stream;

  dispose() {
    // this._compassStream.stream.drain();
    // this._compassStream.close();
    this._listAngleStream = null;
    FlutterCompass.events.drain();
  }
}
