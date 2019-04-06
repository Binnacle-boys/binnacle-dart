import 'dart:async';
import './providers/position_provider.dart';
import './providers/weather_provider.dart';
import 'models/position_model.dart';
import 'models/weather_model.dart';

class Repository {
  // final moviesApiProvider = MovieApiProvider();
  final positionProvider = PositionProvider();
  final weatherProvider = WeatherProvider();

  Future<WeatherModel> fetchWeather(lat, lon) {
    return weatherProvider.fetchWeather(lat, lon); 
  }
  Stream<PositionModel> getPositionStream() => positionProvider.position;

  // Future<ItemModel> fetchAllMovies() => moviesApiProvider.fetchMovieList();
}