import 'dart:async';

import 'sensor_provider.dart';
import 'package:sos/services/compass/phone_compass_service.dart';

class CompassProvider extends SensorProvider {
  CompassProvider() : super() {
    print('compass provider constructor');
    add(new PhoneCompassService());
    print('added phone compass service');
  }
}
