import 'dart:async';
import 'package:rxdart/rxdart.dart';

import './providers/position_provider.dart';
import './providers/wind_provider.dart';
import './providers/compass_provider.dart';

import './services/geolocation_service.dart';
import './services/weather_service.dart';
import './services/test_compass_service.dart';

import 'models/position_model.dart';
import 'models/compass_model.dart';
import 'models/wind_model.dart';

class Repository {
  PositionProvider _positionProvider;
  WindProvider _windProvider;
  CompassProvider _compassProvider;

  Repository(BehaviorSubject<PositionModel> positionStream) {
    this._positionProvider =
        PositionProvider(service: new GeolocationService());
    this._windProvider =
        WindProvider(service: new WeatherService(positionStream));
    this._compassProvider = CompassProvider(service: new TestCompassService());
  }

  swapCompassStream() {
    this._compassProvider.changeService(new TestCompassService());
  }

  Stream<WindModel> getWindStream() => _windProvider.wind.stream;
  Stream<PositionModel> getPositionStream() =>
      _positionProvider.position.stream;
  Stream<CompassModel> getCompassStream() => _compassProvider.compass.stream;
}
