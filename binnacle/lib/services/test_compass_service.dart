import 'dart:async';
import '../models/compass_model.dart';
import '../models/compass_service_interface.dart';
import './service_wrapper_interface.dart';
import '../models/service_data.dart';
<<<<<<< HEAD
import '../enums.dart';
class TestCompassService extends ICompassService {
=======
>>>>>>> pr_us3

class TestCompassService extends ICompassService {
  StreamController<CompassModel> _compassStream = StreamController();
  List<CompassModel> _dummyData = [];

  TestCompassService() {
    buildDummyData();
    _compassStream.sink.addStream(Stream.fromIterable(this._dummyData));
  }
  buildDummyData() {
    for (double i = 1.0; i < 3.0; i = i + 1.0) {
      this._dummyData.add(new CompassModel(direction: i));
    }
  }

  dispose() async {
    await _compassStream.close();
  }

  StreamController<CompassModel> get compassStream => _compassStream;
}

<<<<<<< HEAD
class MockCompassServiceWrapper extends ServiceWrapper{
  final ServiceData _serviceData = ServiceData(ProviderType.compass, 'mock compass', 0);
=======
class MockCompassServiceWrapper extends ServiceWrapper {
  final ServiceData _serviceData = ServiceData('compass', 'mock compass', 0);
>>>>>>> pr_us3
  final bool _default;

  MockCompassServiceWrapper(this._default);

  get service => TestCompassService();
  ServiceData get serviceData => this._serviceData;
  bool get isDefault => this._default;
}
