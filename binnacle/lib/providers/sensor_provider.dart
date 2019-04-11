import 'dart:developer';

import 'package:sos/services/sensor_service.dart';

class SensorProvider {
  List<SensorService> children;

  Stream<dynamic> get stream {
    /// TODO: This doesn't work like I hoped, going to
    /// implement Observables on the service working
    /// make the getActive() an O(1) function and working
    /// list an O(1) function
    /// Method involves separating into working and nonworking
    /// children that are already sorted
    if (_stream == null && children.isNotEmpty) {
      /// NOTE: This assumes services handle updating working
      _stream = getActive().stream;
    }
    return _stream;
  }

  Stream<dynamic> _stream;

  /// This is for knowing if we should be auto-updating priorities
  /// TODO: Convert this to a getter with a private field
  bool manual = false;

  SensorProvider() {
    children = new List();
  }

  List<SensorService> getWorkingList() {
    List<SensorService> services = children.toList();

    List<SensorService> workingSerivces = new List();
    for (SensorService service in services) {
      if (service.working) workingSerivces.add(service);
    }

    return workingSerivces;
  }

  void add(SensorService child) {
    children.add(child);
    children.sort((a, b) => a.accuracy.compareTo(b.accuracy));

    _stream = getActive().stream;
  }

  SensorService getActive() {
    List<SensorService> services = children.toList();

    for (SensorService service in services) {
      if (service.working) return service;
    }

    return null;
  }

  void set(SensorService service) {
    if (!children.contains(service)) {
      throw new Exception('$service was not found');
    }

    manual = true;
    _stream = service.stream;

    log('Manually set $service as the SensorModule service');
  }

  void reset() {
    _stream = getActive().stream;
    manual = false;

    log('Reset the SensorModule');
  }
}
