import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';

import 'package:rxdart/subjects.dart';

class BluetoothManager {
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  /// Scanning
  StreamSubscription _scanSubscription;
  Map<DeviceIdentifier, ScanResult> _scanResults = new Map();
  StreamController _scanResultsStream = StreamController();
  //! bool isScanning = false;
  StreamController<bool> _isScanning = StreamController();

  /// State
  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;

  // Device
  BluetoothDevice device;
  bool get _isConnected => (device != null);
  StreamController<bool> isConnected = StreamController();
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;
  List<BluetoothService> services = new List();
  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;
  StringBuffer _buffer = StringBuffer();
  BehaviorSubject bluetoothDataStream = BehaviorSubject();

  BluetoothManager() {
    // Immediately get the state of FlutterBlue
    _flutterBlue.state.then((s) {
      state = s;
    });

    // Subscribe to state changes
    _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
      state = s;
    });

    // set scanning to false so the UI can reflect this state
    _isScanning.add(false);
    isConnected.add(_isConnected);
  }

  _startScan() {
    _isScanning.add(true);

    _scanSubscription = _flutterBlue
        .scan(
      timeout: const Duration(seconds: 5),
      /*withServices: [
          new Guid('0000180F-0000-1000-8000-00805F9B34FB')
        ]*/
    )
        // .where((data) => data.advertisementData.localName == "Donovan's Bose" )
        .listen((scanResult) {
      // print('localName: ${scanResult.advertisementData.localName}');
      // print('manufacturerData: ${scanResult.advertisementData.manufacturerData}');
      // print('serviceData: ${scanResult.advertisementData.serviceData}');

      _scanResults[scanResult.device.id] = scanResult;
      _scanResultsStream.add(_scanResults);
    }, onDone: _stopScan);
  }

  _stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;

    _isScanning.add(false);
  }

  _connect(BluetoothDevice d) async {
    device = d;
    isConnected.add(_isConnected);

    // Connect to device
    deviceConnection = _flutterBlue
        .connect(device, timeout: const Duration(seconds: 4))
        .listen(
      (d) {
        print("_connect d: " + d.toString());
        print("_connect device: " + device.toString());
      },

      onDone:
          _disconnect, //? Will this work for our case? Should we have an onDone handler?
    );

    // Update the connection state immediately
    await device.state.then((s) {
      deviceState = s;
    });

    // Subscribe to connection changes
    deviceStateSubscription = device.onStateChanged().listen((s) {
      deviceState = s;
      if (s == BluetoothDeviceState.connected) {
        device.discoverServices().then((s) {
          services = s;
          services.forEach((service) {
            print(service.toString());
            service.characteristics.forEach((c) {
              _setNotification(c);
            });
          });
        });
      }
    });

  }

  _disconnect() {
    // Remove all value changed listeners
    valueChangedSubscriptions.forEach((uuid, sub) => sub.cancel());
    valueChangedSubscriptions.clear();
    deviceStateSubscription?.cancel();
    deviceStateSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    device = null;
    isConnected.add(_isConnected);
  }

  // t

  // _writeCharacteristic(BluetoothCharacteristic c) async {
  //   await device.writeCharacteristic(c, [0x12, 0x34],
  //       type: CharacteristicWriteType.withResponse);

  // }

  // _readDescriptor(BluetoothDescriptor d) async {
  //   await device.readDescriptor(d);

  // }

  // _writeDescriptor(BluetoothDescriptor d) async {
  //   await device.writeDescriptor(d, [0x12, 0x34]);

  // }

  _setNotification(BluetoothCharacteristic c) async {
    if (c.isNotifying) {
      await device.setNotifyValue(c, false);
      // Cancel subscription
      await valueChangedSubscriptions[c.uuid]?.cancel();
      valueChangedSubscriptions.remove(c.uuid);
    } else {
      await device.setNotifyValue(c, true);
      // ignore: cancel_subscriptions
      final sub = device.onValueChanged(c).listen((d) {
        bluetoothDataStream.addStream(_test(String.fromCharCodes(d)));

        bluetoothDataStream.listen((d) => print(d.toString()));
      });
      // Add to map
      valueChangedSubscriptions[c.uuid] = sub;
    }
  }

  Stream _test(input) async* {
    print(input);
    _buffer.write(input);
    if (_buffer.toString().contains('\n') && _buffer.toString().length > 5) {
      List<String> temp = _buffer.toString().split('\n');
      _buffer.clear();

      yield temp[0];
    }

  }

  // _refreshDeviceState(BluetoothDevice d) async {
  //   var state = await d.state;
  //     deviceState = state;
  //     // print('State refreshed: $deviceState');
  // }

  StreamController get isScanning => _isScanning;
  StreamController get scanResults => _scanResultsStream;
  Function get startScan => _startScan();
  Function get connect => _connect;

  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
  }
}
