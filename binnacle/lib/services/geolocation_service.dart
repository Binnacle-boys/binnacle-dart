import 'dart:async';
import '../models/position_model.dart';
import '../providers/position_provider.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationService extends IPositionService {
  @override
  final Geolocator _geolocator = Geolocator();
  // TODO possibly change distance filter and accuracy (this weekend in don's car)
  final LocationOptions _locationOptions =
      LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 1);
  StreamController<PositionModel> _positionStream = StreamController();

  GeolocationService() {
    _positionStream.addStream(_geolocator
        .getPositionStream(_locationOptions)
        .map((Position position) => PositionModel(
            lat: position.latitude,
            lon: position.longitude,
            speed: position.speed)));
    //.where((PositionModel position) => position.speed != -1.0));
  }
  StreamController<PositionModel> get positionStream => _positionStream;
}
