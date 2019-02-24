import 'package:flutter_blue/flutter_blue.dart';

class BluetoothManager{

  FlutterBlue flutterBlue;

  BluetoothManager(){
    flutterBlue = FlutterBlue.instance;
  }

  void printDevices(){
    flutterBlue.state.then((state){
      print("Bluetooth state: " + state.toString());
    });
    flutterBlue.scan().listen((ScanResult scanResult){
      if(scanResult != null){
        print(scanResult.device.name);
      }
    });
  }

}