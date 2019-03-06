import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

/// A rudimentary class to handle Bluetooth device interactions.

class BluetoothManager{

  FlutterBlue flutterBlue;
  FlutterBluetoothSerial flutterBluetoothSerial;

  BluetoothManager(){
    flutterBlue = FlutterBlue.instance;
    flutterBluetoothSerial = FlutterBluetoothSerial.instance;
  }

  /// Print list of Bluetooth devices that are currently nearby and in discovery mode.
  void printDevices(){
    flutterBlue.state.then((state){
      print("Bluetooth state: " + state.toString());
    });
    flutterBlue.scan().listen((ScanResult scanResult){
      if(scanResult != null){
        print(scanResult.device.name + " " + scanResult.device.id.toString());
      }
    });
    flutterBluetoothSerial.getBondedDevices().then((list){
      print("Bonded Serial Devices: "+list.toString());
    });
  }

}