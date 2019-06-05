import 'dart:async';
import '../models/wind_model.dart';
import '../models/wind_service_interface.dart';
import '../models/service_data.dart';
import './service_wrapper_interface.dart';
import '../enums.dart';
import 'package:flutter/foundation.dart';

import 'bluetooth_parser.dart';

class BluetoothWindService extends IWindService {
  StreamController<WindModel> _stream = StreamController();
  StreamController _bt;
  // Stream _bluetoothStream;

  BluetoothWindService(StreamController btStream) {
    _bt = btStream;
    _bt.stream.listen((data) {
      (!_stream.isClosed) ?
        _stream.add(bluetoothParser(data, ProviderType.wind)) : null ;
      
    });
  }
  dispose() async {
    await _stream.close();

  }
  StreamController<WindModel> get windStream => _stream;

}

class BluetoothWindServiceWrapper implements ServiceWrapper{
  final ServiceData _serviceData = ServiceData(ProviderType.wind, 'bluetooth wind', 1);
  final bool _default = false;
  StreamController _bluetoothStream;

  BluetoothWindServiceWrapper({ @required StreamController bluetooth }) {
    _bluetoothStream = bluetooth;
  }

  get service =>  BluetoothWindService(_bluetoothStream);
  ServiceData get serviceData => this._serviceData;
  bool get isDefault => this._default;

}
