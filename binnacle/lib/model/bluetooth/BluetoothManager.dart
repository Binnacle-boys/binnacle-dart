import 'package:flutter_blue/flutter_blue.dart' as fb;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// /// A rudimentary class to handle Bluetooth device interactions.

// class BluetoothManager{

  fb.FlutterBlue flutterBlue;
  FlutterBluetoothSerial flutterBluetoothSerial;

  BluetoothManager(){
    flutterBlue = fb.FlutterBlue.instance;
    flutterBluetoothSerial = FlutterBluetoothSerial.instance;
  }

  /// Print list of Bluetooth devices that are currently nearby and in discovery mode.
  void printDevices(){
//    flutterBlue.state.then((state){
//      print("Bluetooth state: " + state.toString());
//    });
//    flutterBlue.scan().listen((ScanResult scanResult){
//      if(scanResult != null){
//        print(scanResult.device.name + " " + scanResult.device.id.toString());
//      }
//    });
    flutterBluetoothSerial.getBondedDevices().then((list){
//      print("Bonded Serial Device List: "+list.toString());
      list.forEach((device){
        BluetoothDevice btd = device as BluetoothDevice;
        print("BtDevice: "+btd.name);
        print("Address: "+btd.address.toString());
        print("Connected State: "+btd.connected.toString()+"\n");
        if(btd.name == "HC-05"){
          connectAndRead(btd);
        }
      });
    });
  }

  void connectAndRead(BluetoothDevice btd){
    flutterBluetoothSerial.isConnected.then((connected){
      if(connected){
        flutterBluetoothSerial.onRead().listen((data){
          print(data);
        });
      }
      else{
        flutterBluetoothSerial.connect(btd);
        flutterBluetoothSerial.onRead().listen((data){
          print(data);
        });
      }
    });
  }

}