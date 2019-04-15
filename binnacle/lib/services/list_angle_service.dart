import 'dart:async';
import 'dart:core';
import 'package:rxdart/rxdart.dart';
import 'package:sos/models/list_angle_model.dart';
import 'package:sos/providers/list_angle_provider.dart';

import 'package:sensors/sensors.dart';
import 'package:flutter_compass/flutter_compass.dart';

class ListAngleService extends IListAngleService {
  BehaviorSubject<ListAngleModel> _listAngleStream =
      BehaviorSubject(seedValue: ListAngleModel(angle: 0.0));

  ListAngleService() {
    print('Initializing ListAngle Service');
    // _listAngleStream.addStream(Lista)
    double delta = 1.0;
    accelerometerEvents.listen((data) async {
      var a =
          await ListAngleModel.fromAccelerometerEvent(accelerometerEvent: data);
      //print("_______________" + a.angle.toString());
      var b = await this._listAngleStream.stream.value;
      // print("___" + b.angle.toString());
      double c = (a.angle - b.angle) > 0
          ? a.angle - b.angle
          : (a.angle - b.angle) * -1;

      if (c > delta) {
        _listAngleStream.sink.add(a);
        print("_______________" + a.angle.toString());
      }
    });
    //if (! _listAngleStream.stream.isEmpty )

    // _listAngleStream.addStream(accelerometerEvents.map(
    //     (AccelerometerEvent ae) =>

    //         ListAngleModel.fromAccelerometerEvent(accelerometerEvent: ae)));
  }
  Stream<ListAngleModel> get listAngleStream => _listAngleStream.stream;

  dispose() {
    this._listAngleStream.stream.drain();
    this._listAngleStream = null;
    accelerometerEvents.drain();
  }
}
