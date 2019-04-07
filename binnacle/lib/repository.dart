import 'dart:async';
import 'package:rxdart/rxdart.dart';

import './providers/position_provider.dart';
import './providers/geolocation_service.dart';
import './providers/weather_provider.dart';
import 'models/position_model.dart';
import 'providers/wind_provider.dart';
import 'models/wind_model.dart';

class Repository {
  PositionProvider _positionProvider;
  WindProvider _windProvider;

  Repository(BehaviorSubject<PositionModel> positionStream) {
    this._windProvider = WindProvider( windService: new WeatherProvider(positionStream));
    this._positionProvider = PositionProvider( positionService: new GeolocationService());
  }


  Stream<WindModel> getWindStream() => _windProvider.wind.stream;
  Stream<PositionModel> getPositionStream() => _positionProvider.position.stream;

  // Future<ItemModel> fetchAllMovies() => moviesApiProvider.fetchMovieList();
}