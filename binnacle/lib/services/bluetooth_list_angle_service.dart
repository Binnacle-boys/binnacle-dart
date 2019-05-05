import 'dart:async';
import '../models/list_angle_model.dart';
import '../models/list_angle_service_interface.dart';
import '../models/service_data.dart';
import './service_wrapper_interface.dart';
import '../enums.dart';
import 'package:flutter/foundation.dart';

import 'bluetooth_parser.dart';

class BluetoothListAngleService extends IListAngleService {
  StreamController<ListAngleModel> _stream = StreamController();
  StreamController _bt;
  // Stream _bluetoothStream;

  BluetoothListAngleService(StreamController btStream) {
    _bt = btStream;
    _bt.stream.listen((data) {
      (!_stream.isClosed) ?
        _stream.add(bluetoothParser(data, ProviderType.list_angle)) : null ;
      
    });
  }
  dispose() async {
    await _stream.close();

  }
  StreamController<ListAngleModel> get listAngleStream => _stream;

}

class BluetoothListAngleServiceWrapper implements ServiceWrapper{
  final ServiceData _serviceData = ServiceData(ProviderType.list_angle, 'bluetooth list angle', 1);
  final bool _default = false;
  StreamController _bluetoothStream;

  BluetoothListAngleServiceWrapper({ @required StreamController bluetooth }) {
    _bluetoothStream = bluetooth;
  }

  get service =>  BluetoothListAngleService(_bluetoothStream);
  ServiceData get serviceData => this._serviceData;
  bool get isDefault => this._default;

}
