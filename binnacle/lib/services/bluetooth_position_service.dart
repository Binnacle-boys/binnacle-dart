import 'dart:async';
import '../models/position_model.dart';
import '../models/position_service_interface.dart';
import '../models/service_data.dart';
import './service_wrapper_interface.dart';
import '../enums.dart';
import 'package:flutter/foundation.dart';

import 'bluetooth_parser.dart';

class BluetoothPositionService extends IPositionService {
  StreamController<PositionModel> _stream = StreamController();
  StreamController _bt;
  // Stream _bluetoothStream;

  BluetoothPositionService(StreamController btStream) {
    _bt = btStream;
    _bt.stream.listen((data) {
      (!_stream.isClosed) ?
        _stream.add(bluetoothParser(data, ProviderType.position)) : null ;
      
    });
  }
  dispose() async {
    await _stream.close();

  }
  StreamController<PositionModel> get positionStream => _stream;

}

class BluetoothPositionServiceWrapper implements ServiceWrapper{
  final ServiceData _serviceData = ServiceData(ProviderType.position, 'bluetooth position', 1);
  final bool _default = false;
  StreamController _bluetoothStream;

  BluetoothPositionServiceWrapper({ @required StreamController bluetooth }) {
    _bluetoothStream = bluetooth;
  }

  get service =>  BluetoothPositionService(_bluetoothStream);
  ServiceData get serviceData => this._serviceData;
  bool get isDefault => this._default;

}
