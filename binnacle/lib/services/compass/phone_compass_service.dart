import 'dart:async';
import 'dart:developer';

import 'package:sos/services/sensor_service.dart';
import 'package:sos/models/compass_model.dart';
import 'package:flutter_compass/flutter_compass.dart';

class PhoneCompassService extends SensorService {
  PhoneCompassService() : super('SensorCompassPhone', 2) {
    controller = new StreamController<CompassModel>.broadcast();

    print('constructing phone compass service');
    workingStream.add(true);

    FlutterCompass.events.listen((double data) {
      controller.add(new CompassModel(direction: data));
      workingStream.add(true);
    });

//    controller.addStream(
//        FlutterCompass.events.map((double d) => CompassModel(direction: d)));

    /// NOTE: I don't know if errors stop a stream
    stream.handleError((error) {
      log('FlutterCompass encountered an error: $error');
      workingStream.add(false);
    });
  }
}
