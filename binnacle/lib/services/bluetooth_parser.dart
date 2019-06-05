import 'package:sos/models/compass_model.dart';
import 'package:sos/models/position_model.dart';
import 'package:sos/models/wind_model.dart';
import '../enums.dart';

//TODO: update packet format annotation
//  The bluetooth parser it pased on the following implementation of the packet:
//  index| example | type
//    0 $GNOST, 
//    1 filtered: 1,
//    2 36.30: (lat: straight from gps to 2 decimal places), 
//    3 122.69 (long: straight from gps to 2 decimal places), 

//    4 3.34 (wind speed: knots to 2 decimal places), 
//    5 102.12 (wind dir: degrees to 2 decimal places), 
//    6 1.22 (speed over ground: knots to 2 decimal places),
//    7 260.68 (heading over ground: degrees to 2 decimal places), 
//    8 80 (boom angle: degrees - no decimal places), 
//    9 023412 (timestamp: hhmmss)
//    10 *6A: (checksum)

dynamic bluetoothParser(String packet, ProviderType modelType) {
  // print("modelType : " + modelType.toString().split('.').last);
  List splitPacket = packet.split(",");
  switch (modelType) {
    case ProviderType.compass:
      return new CompassModel(direction: double.parse(splitPacket[7]));
      break;
    case ProviderType.wind:
      return new WindModel(double.parse(splitPacket[4]), double.parse(splitPacket[5]));
      break;
    case ProviderType.position:
      return new PositionModel(lat:double.parse(splitPacket[2]), lon: double.parse(splitPacket[3]), speed: double.parse(splitPacket[6]));
      break;
    case ProviderType.list_angle:
      print("List angle not implemented in the bluetooth packet yet");
      break;
    default:
      throw Exception("Unknown parameter modelType. bluetoothParser only accepts the folowing modelTypes: compass, wind, position, list_angle");
  }
}
