import 'dart:async';
import '../models/position_model.dart';
import '../models/position_service_interface.dart';
import 'package:geolocator/geolocator.dart';
import './service_wrapper_interface.dart';
import '../models/service_data.dart';
import '../enums.dart';

class GeolocationService extends IPositionService {

  final Geolocator _geolocator = Geolocator();
  StreamSubscription _subscription;

  // TODO possibly change distance filter and accuracy (this weekend in don's car)
  final LocationOptions _locationOptions =
      LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 2);
      
  StreamController<PositionModel> _positionStream = StreamController();

  GeolocationService() {

    _subscription = 
      _geolocator.getPositionStream(_locationOptions).listen((Position position) => 
        _positionStream.sink.add(PositionModel(
          lat: position.latitude,
          lon: position.longitude,
          speed: position.speed
        ))
      );
  }
  dispose() async {
    await _subscription.pause();
    await _positionStream.close();

  }
  StreamController<PositionModel> get positionStream => _positionStream;
}


class GeolocationServiceWrapper implements ServiceWrapper{
  final ServiceData _serviceData = ServiceData(ProviderType.position, 'geolocation', 1);
  final bool _default = true;

  GeolocationServiceWrapper();

  get service =>  GeolocationService();
  ServiceData get serviceData => this._serviceData;
  bool get isDefault => this._default;

}
