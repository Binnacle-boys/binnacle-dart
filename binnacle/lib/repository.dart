import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:sos/services/compass_service.dart';
import 'package:sos/models/list_angle_model.dart';
import 'package:sos/providers/list_angle_provider.dart';
import 'package:sos/services/list_angle_service.dart';

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
  ListAngleProvider _listAngleProvider;

  Repository(BehaviorSubject<PositionModel> positionStream) {
    this._positionProvider =
        PositionProvider(service: new GeolocationService());
    this._windProvider =
        WindProvider(service: new WeatherService(positionStream));
    this._compassProvider = CompassProvider(service: new CompassService());
    this._listAngleProvider =
        new ListAngleProvider(service: new ListAngleService());
  }

  swapCompassStream() {
    this._compassProvider.changeService(new TestCompassService());
  }

  Stream<WindModel> getWindStream() => _windProvider.wind.stream;
  Stream<PositionModel> getPositionStream() =>
      _positionProvider.position.stream;
  Stream<CompassModel> getCompassStream() => _compassProvider.compass.stream;
  Stream<ListAngleModel> getListAngleStream() =>
      _listAngleProvider.listAngle.stream;
}
