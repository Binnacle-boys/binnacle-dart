// import 'package:flutter_blue/flutter_blue.dart';

// /// A rudimentary class to handle Bluetooth device interactions.

// class BluetoothManager{

//   FlutterBlue flutterBlue;

//   BluetoothManager(){
//     flutterBlue = FlutterBlue.instance;
//   }

//   /// Print list of Bluetooth devices that are currently nearby and in discovery mode.
//   void printDevices(){
//     flutterBlue.state.then((state){
//       print("Bluetooth state: " + state.toString());
//     });
//     flutterBlue.scan().listen((ScanResult scanResult){
//       if(scanResult != null){
//         print(scanResult.device.name + " " + scanResult.device.id.toString());
//       }
//     });
//   }

// }