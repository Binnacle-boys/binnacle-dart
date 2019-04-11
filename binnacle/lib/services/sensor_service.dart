class SensorService implements Comparable<SensorService> {
  /// Used in the PriorityQueue for getting the most accurate SensorService
  int get accuracy => _accuracy;
  int _accuracy;

  /// Is this Service currently giving valid data?
  /// Implement this as the observable piece of data we want to follow
  /// With this knowledge, we can adjust our priority queue and use a general children list,
  /// and have the priority queue be of just working services
//  bool get working => _working;
//  bool _working;
  bool working = true;

  Stream<dynamic> stream;

  String _name = 'SensorServiceDefaultName';

  String toString() => _name;

  SensorService(this._name, this._accuracy, this.stream);

  @override
  int compareTo(SensorService other) {
    return accuracy.compareTo(other.accuracy);
  }
}
