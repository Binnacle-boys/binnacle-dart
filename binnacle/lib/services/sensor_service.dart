import 'dart:async';

class SensorService implements Comparable<SensorService> {
  /// Used in the PriorityQueue for getting the most accurate SensorService
  int get accuracy => _accuracy;
  int _accuracy;

  /// The data from the service
  Stream<dynamic> stream;

  /// Is this Service currently giving valid data?
  StreamController<bool> working;

  String _name = 'SensorServiceDefaultName';

  SensorService(this._name, this._accuracy, this.stream);

  String toString() => _name;

  @override
  int compareTo(SensorService other) {
    return accuracy.compareTo(other.accuracy);
  }
}
