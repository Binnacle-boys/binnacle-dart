import 'dart:async';
import 'dart:developer';

class SensorService implements Comparable<SensorService> {
  /// Used in the PriorityQueue for getting the most accurate SensorService
  int get accuracy => _accuracy;
  int _accuracy;

  /// The data from the service
  Stream<dynamic> stream;

  /// Is this Service currently giving valid data?
  StreamController<bool> workingStream;
  bool working;

  String _name = 'SensorServiceDefaultName';

  SensorService(this._name, this._accuracy, this.stream) {
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
