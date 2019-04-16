import 'dart:core';
import 'dart:developer';
import 'dart:async';

import 'package:sos/services/sensor_service.dart';
import 'package:sos/models/model.dart';

class SensorProvider {
  List<SensorService> workingChildren;
  List<SensorService> inactiveChildren;

  SensorService active;

  StreamController<Model> controller;

  bool get manual => _manual;
  bool _manual = false;

  SensorProvider() {
    controller = new StreamController.broadcast();

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
        if (active == child) {
          return;
        }

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
    clean();

    if (workingChildren.isEmpty) {
      print('no good children able to take over');
      return;
    }

    print('updating the current active service');
    active = workingChildren.first;
    controller.addStream(active.stream);
  }

  // Cleans the controller of old streams
  void clean() {
    active?.stream?.drain();
    active = null;
  }

  void set(SensorService service) {
    if (!workingChildren.contains(service)) {
      throw new Exception('$service was not found as a working child');
    }

    clean();

    _manual = true;
    active = service;
    controller.addStream(active.stream);

    log('Manually set $service as the SensorModule service');
  }

  void reset() {
    updateActive();
    _manual = false;

    log('Reset the SensorModule');
  }
}
