import 'package:flutter/material.dart';
import '../ui/app_drawer.dart';
import 'package:rxdart/rxdart.dart';
import '../bloc.dart';
import '../providers/app_provider.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';

class FlutterBlueApp extends StatefulWidget {
  FlutterBlueApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FlutterBlueAppState createState() => new _FlutterBlueAppState();
}


class _FlutterBlueAppState extends State<FlutterBlueApp> {

  FlutterBlue _flutterBlue = FlutterBlue.instance;


  /// Scanning
  StreamSubscription _scanSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  //! bool isScanning = false;
  PublishSubject<bool> isScanning = PublishSubject();
  
  /// State
  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;

  // Device
  BluetoothDevice device;
  bool get isConnected => (device != null);
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;
  List<BluetoothService> services = new List();
  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;

  @override
  void initState() {
    super.initState();

    // Immediately get the state of FlutterBlue
    _flutterBlue.state.then((s) {
      setState(() {
        state = s;
      });
    });
    // Subscribe to state changes
    _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
      setState(() {
        state = s;
      });
    });
    print("INITSTATE --- ADDING FALSE");
    isScanning.add(false);
    isScanning.listen((onData) {
      print("FROM LISTENER "+ onData.toString());
    });

  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    super.dispose();
  }

  _startScan() {
    _scanSubscription = _flutterBlue
    .scan(
      timeout: const Duration(seconds: 5),
      /*withServices: [
          new Guid('0000180F-0000-1000-8000-00805F9B34FB')
        ]*/
    )
    .where((data) => data.advertisementData.localName == "Donovan's Bose" )
    .listen((scanResult) {
      // print('localName: ${scanResult.advertisementData.localName}');
      // print('manufacturerData: ${scanResult.advertisementData.manufacturerData}');
      // print('serviceData: ${scanResult.advertisementData.serviceData}');
      setState(() {
        scanResults[scanResult.device.id] = scanResult;
      });
    }, onDone: _stopScan);
    
    print("STARTSCAN --- ADDING TRUE");
    isScanning.add(true);
    checkEmpty();
    
    // setState(() {
    //   isScanning = true;
    // });
    
  }
  checkEmpty()async {
    var empty =  await isScanning.isEmpty;
    print('ISEMPTY?: '+ empty.toString());

  }

  _stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    // setState(() {
    //   isScanning = false;
    // });
    print("STOPSCAN --- ADDING FALSE");
    isScanning.add(false);
  }

  _connect(BluetoothDevice d) async {
    device = d;
    // Connect to device
    deviceConnection = _flutterBlue
        .connect(device, timeout: const Duration(seconds: 4))
        .listen(
          null,
          onDone: _disconnect,
        );

    // Update the connection state immediately
    device.state.then((s) {
      setState(() {
        deviceState = s;
      });
    });

    // Subscribe to connection changes
    deviceStateSubscription = device.onStateChanged().listen((s) {
      setState(() {
        deviceState = s;
      });
      if (s == BluetoothDeviceState.connected) {
        device.discoverServices().then((s) {
          setState(() {
            services = s;
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
    setState(() {
      device = null;
    });
  }

  _readCharacteristic(BluetoothCharacteristic c) async {
    await device.readCharacteristic(c);
    setState(() {});
  }

  _writeCharacteristic(BluetoothCharacteristic c) async {
    await device.writeCharacteristic(c, [0x12, 0x34],
        type: CharacteristicWriteType.withResponse);
    setState(() {});
  }

  _readDescriptor(BluetoothDescriptor d) async {
    await device.readDescriptor(d);
    setState(() {});
  }

  _writeDescriptor(BluetoothDescriptor d) async {
    await device.writeDescriptor(d, [0x12, 0x34]);
    setState(() {});
  }

  _setNotification(BluetoothCharacteristic c) async {
    if (c.isNotifying) {
      await device.setNotifyValue(c, false);
      // Cancel subscription
      valueChangedSubscriptions[c.uuid]?.cancel();
      valueChangedSubscriptions.remove(c.uuid);
    } else {
      await device.setNotifyValue(c, true);
      // ignore: cancel_subscriptions
      final sub = device.onValueChanged(c).listen((d) {
        setState(() {
          // print('onValueChanged $d');
        });
      });
      // Add to map
      valueChangedSubscriptions[c.uuid] = sub;
    }
    setState(() {});
  }

  _refreshDeviceState(BluetoothDevice d) async {
    var state = await d.state;
    setState(() {
      deviceState = state;
      // print('State refreshed: $deviceState');
    });
  }

  // _buildScanningButton() {
  //   if (isConnected || state != BluetoothState.on) {
  //     return null;
  //   }
  //   if (isScanning) {
  //     return new FloatingActionButton(
  //       child: new Icon(Icons.stop),
  //       onPressed: _stopScan,
  //       backgroundColor: Colors.red,
  //     );
  //   } else {
  //     return new FloatingActionButton(
  //         child: new Icon(Icons.search), onPressed: _startScan);
  //   }
  // }

  _buildScanResultTiles() {
    return scanResults.values
        .map((r) => ScanResultTile(
              result: r,
              onTap: () => _connect(r.device),
            ))
        .toList();
  }

  // List<Widget> _buildServiceTiles() {
  //   return services
  //       .map(
  //         (s) => new ServiceTile(
  //               service: s,
  //               characteristicTiles: s.characteristics
  //                   .map(
  //                     (c) => new CharacteristicTile(
  //                           characteristic: c,
  //                           onReadPressed: () => _readCharacteristic(c),
  //                           onWritePressed: () => _writeCharacteristic(c),
  //                           onNotificationPressed: () => _setNotification(c),
  //                           descriptorTiles: c.descriptors
  //                               .map(
  //                                 (d) => new DescriptorTile(
  //                                       descriptor: d,
  //                                       onReadPressed: () => _readDescriptor(d),
  //                                       onWritePressed: () =>
  //                                           _writeDescriptor(d),
  //                                     ),
  //                               )
  //                               .toList(),
  //                         ),
  //                   )
  //                   .toList(),
  //             ),
  //       )
  //       .toList();
  // }

  _buildActionButtons() {
    if (isConnected) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () => _disconnect(),
        )
      ];
    }
  }

  _buildAlertTile() {
    return new Container(
      color: Colors.redAccent,
      child: new ListTile(
        title: new Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.subhead,
        ),
        trailing: new Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.subhead.color,
        ),
      ),
    );
  }

  _buildDeviceStateTile() {
    return new ListTile(
        leading: (deviceState == BluetoothDeviceState.connected)
            ? const Icon(Icons.bluetooth_connected)
            : const Icon(Icons.bluetooth_disabled),
        title: new Text('Device is ${deviceState.toString().split('.')[1]}.'),
        subtitle: new Text('${device.id}'),
        trailing: new IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _refreshDeviceState(device),
          color: Theme.of(context).iconTheme.color.withOpacity(0.5),
        ));
  }

  _buildProgressBarTile() {
    return new LinearProgressIndicator();
  }





  //! Testing popup 

  _buildPopup() {
    return FloatingActionButton(backgroundColor: Colors.amber, onPressed: () {
      _startScan();
      showDialog(
        context: context,
        builder: (context) =>
         SimpleDialog(
           title: _popupTitle(context),
          // title: Column(
          //     children: ((isScanning) 
          //       ? <Widget>[LinearProgressIndicator(), Text('Scanning...', style: TextStyle(fontSize: 24.0))]
          //       : <Widget>[Text("Select service" ,style: TextStyle(fontSize: 24.0))]
          //   )
          // ),
          children: _buildScanResultTiles()
        )
    );});
  }

  Widget _popupTitle(BuildContext context) {
    Bloc bloc = Provider.of(context);

    return StreamBuilder(
      stream: bloc.isScanning,
      builder: (context, snapshot)  {
        print("FROM SNAPSHOT "+snapshot.data.toString());
        if(snapshot.hasData) {
          
          return Text(snapshot.data.toString());
        } else if (snapshot.hasError) {
          return Text('snapshot has error');
        } else {
          print("Displaying no data yet");
          return Text('No data yet');
        }
      }
    );
  }

  //! end testing popup

  @override
  Widget build(BuildContext context) {
    var tiles = new List<Widget>();
    if (state != BluetoothState.on) {
      tiles.add(_buildAlertTile());
    }
    if (isConnected) {
      tiles.add(_buildDeviceStateTile());
      // tiles.addAll(_buildServiceTiles());
    } else {
      tiles.addAll(_buildScanResultTiles());
    }


  
   return Scaffold(
     backgroundColor: Colors.grey,
     floatingActionButton:  _buildPopup(),
      // floatingActionButton: _buildScanningButton(),

     appBar: AppBar(
       backgroundColor: Colors.blueGrey,
       title: Text("Test Screen"),
       actions: _buildActionButtons(),

     ),
     drawer: AppDrawer(),
     body: Stack( children: <Widget>[
            //(isScanning) ? _buildProgressBarTile() : new Container(),
            new ListView(
              children: tiles,
            )])
   );
  }
}



//! END page
class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(result.device.name),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  // Widget _buildAdvRow(BuildContext context, String title, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Text(title, style: Theme.of(context).textTheme.caption),
  //         SizedBox(
  //           width: 12.0,
  //         ),
  //         Expanded(
  //           child: Text(
  //             value,
  //             style: Theme.of(context)
  //                 .textTheme
  //                 .caption
  //                 .apply(color: Colors.black),
  //             softWrap: true,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // String getNiceHexArray(List<int> bytes) {
  //   return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
  //       .toUpperCase();
  // }

  // String getNiceManufacturerData(Map<int, List<int>> data) {
  //   if (data.isEmpty) {
  //     return null;
  //   }
  //   List<String> res = [];
  //   data.forEach((id, bytes) {
  //     res.add(
  //         '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
  //   });
  //   return res.join(', ');
  // }

  // String getNiceServiceData(Map<String, List<int>> data) {
  //   if (data.isEmpty) {
  //     return null;
  //   }
  //   List<String> res = [];
  //   data.forEach((id, bytes) {
  //     res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
  //   });
  //   return res.join(', ');
  // }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildTitle(context),
      // leading: Text(result.rssi.toString()),
      trailing: RaisedButton(
        child: Text('CONNECT'),
        color: Colors.black,
        textColor: Colors.white,
        onPressed: (result.advertisementData.connectable) ? onTap : null,
      ),
      //children: <Widget>[
        // _buildAdvRow(
        //     context, 'Complete Local Name', result.advertisementData.localName),
        // _buildAdvRow(context, 'Tx Power Level',
        //     '${result.advertisementData.txPowerLevel ?? 'N/A'}'),
        // _buildAdvRow(
        //     context,
        //     'Manufacturer Data',
        //     getNiceManufacturerData(
        //             result.advertisementData.manufacturerData) ??
        //         'N/A'),
        // _buildAdvRow(
        //     context,
        //     'Service UUIDs',
        //     (result.advertisementData.serviceUuids.isNotEmpty)
        //         ? result.advertisementData.serviceUuids.join(', ').toUpperCase()
        //         : 'N/A'),
        // _buildAdvRow(context, 'Service Data',
        //     getNiceServiceData(result.advertisementData.serviceData) ?? 'N/A'),
      //],
    );
  }
}

// class ServiceTile extends StatelessWidget {
//   final BluetoothService service;
//   final List<CharacteristicTile> characteristicTiles;

//   const ServiceTile({Key key, this.service, this.characteristicTiles})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (characteristicTiles.length > 0) {
//       return new ExpansionTile(
//         title: new Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             const Text('Service'),
//             new Text(
//                 '0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
//                 style: Theme.of(context)
//                     .textTheme
//                     .body1
//                     .copyWith(color: Theme.of(context).textTheme.caption.color))
//           ],
//         ),
//         children: characteristicTiles,
//       );
//     } else {
//       return new ListTile(
//         title: const Text('Service'),
//         subtitle: new Text(
//             '0x${service.uuid.toString().toUpperCase().substring(4, 8)}'),
//       );
//     }
//   }
// }

// class CharacteristicTile extends StatelessWidget {
//   final BluetoothCharacteristic characteristic;
//   final List<DescriptorTile> descriptorTiles;
//   final VoidCallback onReadPressed;
//   final VoidCallback onWritePressed;
//   final VoidCallback onNotificationPressed;

//   const CharacteristicTile(
//       {Key key,
//       this.characteristic,
//       this.descriptorTiles,
//       this.onReadPressed,
//       this.onWritePressed,
//       this.onNotificationPressed})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var actions = new Row(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         new IconButton(
//           icon: new Icon(
//             Icons.file_download,
//             color: Theme.of(context).iconTheme.color.withOpacity(0.5),
//           ),
//           onPressed: onReadPressed,
//         ),
//         new IconButton(
//           icon: new Icon(Icons.file_upload,
//               color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
//           onPressed: onWritePressed,
//         ),
//         new IconButton(
//           icon: new Icon(
//               characteristic.isNotifying ? Icons.sync_disabled : Icons.sync,
//               color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
//           onPressed: onNotificationPressed,
//         )
//       ],
//     );

//     var title = new Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         const Text('Characteristic'),
//         new Text(
//             '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
//             style: Theme.of(context)
//                 .textTheme
//                 .body1
//                 .copyWith(color: Theme.of(context).textTheme.caption.color))
//       ],
//     );

//     if (descriptorTiles.length > 0) {
//       return new ExpansionTile(
//         title: new ListTile(
//           title: title,
//           subtitle: new Text(characteristic.value.toString()),
//           contentPadding: EdgeInsets.all(0.0),
//         ),
//         trailing: actions,
//         children: descriptorTiles,
//       );
//     } else {
//       return new ListTile(
//         title: title,
//         subtitle: new Text(characteristic.value.toString()),
//         trailing: actions,
//       );
//     }
//   }
// }

// class DescriptorTile extends StatelessWidget {
//   final BluetoothDescriptor descriptor;
//   final VoidCallback onReadPressed;
//   final VoidCallback onWritePressed;

//   const DescriptorTile(
//       {Key key, this.descriptor, this.onReadPressed, this.onWritePressed})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var title = new Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         const Text('Descriptor'),
//         new Text(
//             '0x${descriptor.uuid.toString().toUpperCase().substring(4, 8)}',
//             style: Theme.of(context)
//                 .textTheme
//                 .body1
//                 .copyWith(color: Theme.of(context).textTheme.caption.color))
//       ],
//     );
//     return new ListTile(
//       title: title,
//       subtitle: new Text(descriptor.value.toString()),
//       trailing: new Row(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           new IconButton(
//             icon: new Icon(
//               Icons.file_download,
//               color: Theme.of(context).iconTheme.color.withOpacity(0.5),
//             ),
//             onPressed: onReadPressed,
//           ),
//           new IconButton(
//             icon: new Icon(
//               Icons.file_upload,
//               color: Theme.of(context).iconTheme.color.withOpacity(0.5),
//             ),
//             onPressed: onWritePressed,
//           )
//         ],
//       ),
//     );
//   }
// }

