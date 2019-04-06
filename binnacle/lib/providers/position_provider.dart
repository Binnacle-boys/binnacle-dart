import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:geolocator/geolocator.dart';
import '../models/position_model.dart';

// import '../models/item_model.dart';

class PositionProvider {
  final _position = PublishSubject<PositionModel>();

  PositionProvider();


  Stream<PositionModel> get position => _position.stream;



}
abstract class IPositionStrategy {
  // Stream<PositionModel> getPositionStream();

}
// class DeviceStrategy implements IPositionStrategy {
//   var _geolocator = Geolocator();
//   var _locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
//   PublishSubject<PositionModel> _positionStream;

//   DeviceStrategy();

//   PublishSubject<PositionModel> getPosition() {
//     if (_positionStream == null) {
//       Stream<Position> positionStream = Geolocator().getPositionStream(_locationOptions);
//       positionStream.map((Position position ) => toPositionModel(position)
//       );
//     }
//     return _positionStream;
//   }

//   <PositionModel> toPositionModel(Position position ) {
//     return  PositionModel(position.latitude, position.longitude );
//   }

// //  void _toggleListening() {
// //     if (_positionStreamSubscription == null) {

// //       const LocationOptions locationOptions =
// //           LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 10);
// //       final Stream<Position> positionStream =
// //           Geolocator().getPositionStream(locationOptions);
// //       _positionStreamSubscription = positionStream.listen(
// //           (Position position) => _positions.add(position));
// //       _positionStreamSubscription.pause();

// //     }

// //  }

// }