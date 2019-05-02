import 'package:sos/models/compass_model.dart';
import 'package:sos/models/position_model.dart';
import 'package:sos/models/wind_model.dart';

/*
The bluetooth parser it pased on the following implementation of the packet:
index| example | type
   0 $GNOST, 
   1 filtered: 1,
   2 36.30: (lat: straight from gps to 2 decimal places), 
   3 122.69 (long: straight from gps to 2 decimal places), 

   4 3.34 (wind speed: knots to 2 decimal places), 
   5 102.12 (wind dir: degrees to 2 decimal places), 
   6 1.22 (speed over ground: knots to 2 decimal places),
   7 260.68 (heading over ground: degrees to 2 decimal places), 
   8 80 (boom angle: degrees - no decimal places), 
   9 023412 (timestamp: hhmmss)
   10 *6A: (checksum)
*/
dynamic bluetoothParser(String packet, String modelType) {
  print("modelType : " + modelType);
  List splitPacket = packet.split(",");
  switch (modelType) {
    case "compass":
      return new CompassModel(direction: splitPacket[7].toDouble());
      break;
    case "wind":
      return new WindModel(splitPacket[4].toDouble(), splitPacket[5].toDouble());
      break;
    case "position":
      return new PositionModel(lat: splitPacket[4].toDouble(), lon: splitPacket[5].toDouble(), speed: splitPacket[6].toDouble());
      break;
    case "list_angle":
      print("List angle not implemented in the bluetooth packet yet");
      break;
    default:
      throw Exception("Unknown parameter modelType. bluetoothParser only accepts the folowing modelTypes: compass, wind, position, list_angle");
  }
}
