import 'dart:async';
import './providers/position_provider.dart';
import 'models/position_model.dart';
import 'providers/wind_provider.dart';

class Repository {
  // final moviesApiProvider = MovieApiProvider();
  final positionProvider = PositionProvider();
  WindProvider _windProvider;

  Repository(Stream<PositionModel> positionStream) {
    this._windProvider = WindProvider(positionStream);
  }


  Stream<WindModel> getWindStream() => _windProvider.wind.stream;
  Stream<PositionModel> getPositionStream() => positionProvider.position;

  // Future<ItemModel> fetchAllMovies() => moviesApiProvider.fetchMovieList();
}