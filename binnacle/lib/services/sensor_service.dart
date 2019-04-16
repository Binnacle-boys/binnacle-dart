import 'dart:async';
import 'dart:developer';

import 'package:sos/models/model.dart';

class SensorService implements Comparable<SensorService> {
  /// Used in the PriorityQueue for getting the most accurate SensorService
  int get accuracy => _accuracy;
  int _accuracy;

  /// NOTE: This is public for its child
  StreamController<Model> controller;

  /// The data from the service
  Stream<Model> get stream => controller.stream;

  /// Is this Service currently giving valid data?
  StreamController<bool> workingStream;
  bool working;

  String _name = 'SensorServiceDefaultName';

  SensorService(this._name, this._accuracy) {
    controller = new StreamController.broadcast();
    workingStream = new StreamController.broadcast();
    working = false;
    workingStream.stream.listen((work) {
      log('$_name status is now $work');
      working = work;
    });
  }

  String toString() => _name;

  @override
  int compareTo(SensorService other) {
    return accuracy.compareTo(other.accuracy);
  }
}
