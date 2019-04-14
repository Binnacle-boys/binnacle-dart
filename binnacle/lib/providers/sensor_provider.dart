import 'dart:core';
import 'dart:developer';

import 'package:sos/services/sensor_service.dart';

class SensorProvider {
  List<SensorService> workingChildren;
  List<SensorService> inactiveChildren;

  SensorService active;

  Stream<dynamic> stream;

  /// Should we be auto-updating priorities?
  bool get manual => _manual;
  bool _manual = false;

  SensorProvider() {
    workingChildren = new List();
    inactiveChildren = new List();
  }

  void add(SensorService child) {
    log('$child added');

    if (child.working) {
      workingChildren.add(child);
      workingChildren.sort();
    } else {
      inactiveChildren.add(child);
    }

    child.workingStream.stream.listen((working) {
      log('child $child working variable updated to $working');
      if (working) {
        inactiveChildren.remove(child);
        workingChildren.add(child);
        workingChildren.sort();
      } else {
        workingChildren.remove(child);
        inactiveChildren.add(child);
      }

      updateActive();
    });

    updateActive();
  }

  void updateActive() {
    if (workingChildren.isEmpty) {
      active = null;
      stream = null;
      log('no good children able to take over');
      return;
    }
    active = workingChildren.first;
    stream = active.stream;
  }

  void set(SensorService service) {
    if (!workingChildren.contains(service)) {
      throw new Exception('$service was not found as a working child');
    }

    _manual = true;
    stream = service.stream;

    log('Manually set $service as the SensorModule service');
  }

  void reset() {
    updateActive();
    _manual = false;

    log('Reset the SensorModule');
  }
}
