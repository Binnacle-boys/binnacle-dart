import 'dart:async';
import '../models/compass_model.dart';
import '../providers/compass_provider.dart';
import 'package:flutter_compass/flutter_compass.dart';

class CompassService extends ICompassService {
  StreamController<CompassModel> _compassStream = StreamController();

  CompassService() {
    print('Initializing Compass Service');
    //FlutterCompass.events.listen((data) => print(data.toString()));
    _compassStream.addStream(FlutterCompass.events
        .map((double d) => new CompassModel(direction: d)));
    ; // Do I need to listen here?
  }
  Stream<CompassModel> get compassStream => _compassStream.stream;

  dispose() {
    // this._compassStream.stream.drain();
    // this._compassStream.close();
    this._compassStream = null;
    FlutterCompass.events.drain();
  }
}
