import 'dart:async';
import '../models/position_model.dart';
import  './position_provider.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationService extends IPositionService {
  @override
  final Geolocator _geolocator = Geolocator();
  final LocationOptions _locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  StreamController<PositionModel> _positionStream = StreamController();

  GeolocationService() {
    _positionStream.addStream(_geolocator.getPositionStream(_locationOptions)
    .map((Position position) => 
    PositionModel(lat: position.latitude, lon: position.longitude, speed: position.speed)) ); // Do I need to listen here?
  }
  StreamController<PositionModel> get positionStream => _positionStream;

}