import 'dart:async';
import '../models/compass_model.dart';
import '../models/compass_service_interface.dart';
import '../models/service_data.dart';
import './service_wrapper_interface.dart';
import '../enums.dart';
import 'package:flutter/foundation.dart';

import 'bluetooth_parser.dart';

class BluetoothCompassService extends ICompassService {
  StreamController<CompassModel> _compassStream = StreamController();
  StreamController _bt;
  // Stream _bluetoothStream;

  BluetoothCompassService(StreamController btStream) {
    // btStream.listen((data) => bluetoothParser(data, ProviderType.compass));
    _bt = btStream;
    _bt.stream.listen((data) {
      (!_compassStream.isClosed) ?
        _compassStream.add(bluetoothParser(data, ProviderType.compass)) : null ;
      
    });
  }
  dispose() async {
    // await _bt.stream.drain();
    // await _bt.close();
    await _compassStream.close();

  }
  StreamController<CompassModel> get compassStream => _compassStream;

}

class BluetoothCompassServiceWrapper implements ServiceWrapper{
  final ServiceData _serviceData = ServiceData(ProviderType.compass, 'bluetooth compass', 1);
  final bool _default = false;
  StreamController _bluetoothStream;

  BluetoothCompassServiceWrapper({ @required StreamController bluetooth }) {
    _bluetoothStream = bluetooth;
  }

  get service =>  BluetoothCompassService(_bluetoothStream);
  ServiceData get serviceData => this._serviceData;
  bool get isDefault => this._default;

}
