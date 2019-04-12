import 'dart:core';
import 'dart:developer';

import 'package:sos/services/sensor_service.dart';

class SensorProvider {
  List<SensorService> children;
  SensorService active;

  Stream<dynamic> stream;

  /// Should we be auto-updating priorities?
  bool get manual => _manual;
  bool _manual = false;

  SensorProvider() {
    children = new List();
  }

  List<SensorService> getWorkingList() {
    List<SensorService> services = children.toList();

    List<SensorService> workingServices = new List();
    for (SensorService service in services) {
      service.working.stream.last.then((working) {
        if (working) {
          workingServices.add(service);
        }
      });
    }

    return workingServices;
  }

  void add(SensorService child) {
    children.add(child);
    children.sort((a, b) => a.accuracy.compareTo(b.accuracy));

    active = getActive();
    stream = active.stream;
  }

  SensorService getActive() {
    List<SensorService> services = children.toList();

    for (SensorService service in services) {
      service.working.stream.last.then((working) {
        if (working) {
          return service;
        }
      });
    }

    return null;
  }

  void set(SensorService service) {
    if (!children.contains(service)) {
      throw new Exception('$service was not found');
    }

    _manual = true;
    stream = service.stream;

    log('Manually set $service as the SensorModule service');
  }

  void reset() {
    stream = getActive().stream;
    _manual = false;

    log('Reset the SensorModule');
  }
}
