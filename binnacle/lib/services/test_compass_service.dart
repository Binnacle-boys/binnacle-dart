import 'dart:async';
import '../models/compass_model.dart';
import '../models/compass_service_interface.dart';
class TestCompassService extends ICompassService {

  StreamController<CompassModel> _compassStream = StreamController();
  List<CompassModel> _dummyData = [];

  TestCompassService() {
    buildDummyData();
     _compassStream.sink.addStream(Stream.fromIterable(this._dummyData));

  }
  buildDummyData() {
    for(double i = 1.0; i < 10.0; i = i + 1.0) {
      this._dummyData.add(new CompassModel(direction: i));
    }
  }
  dispose() async{
    
    await _compassStream.close();
  }
  StreamController<CompassModel> get compassStream => _compassStream;
}