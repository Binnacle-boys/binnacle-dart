import 'dart:async';
import 'package:rxdart/rxdart.dart';

import './providers/position_provider.dart';
import './providers/weather_provider.dart';
import 'models/position_model.dart';
import 'providers/wind_provider.dart';

class Repository {
  final positionProvider = PositionProvider();
  WindProvider _windProvider;

  Repository(BehaviorSubject<PositionModel> positionStream) {
    this._windProvider = WindProvider( windService: new WeatherProvider(positionStream));
  }


  Stream<WindModel> getWindStream() => _windProvider.wind.stream;
  Stream<PositionModel> getPositionStream() => positionProvider.position;

  // Future<ItemModel> fetchAllMovies() => moviesApiProvider.fetchMovieList();
}