import 'dart:async';
import './providers/position_provider.dart';
import './providers/weather_provider.dart';
import 'models/position_model.dart';
import 'models/weather_model.dart';
import 'providers/wind_provider.dart';

class Repository {
  // final moviesApiProvider = MovieApiProvider();
  final positionProvider = PositionProvider();
  final windProvider = WindProvider();
  // final weatherProvider = WeatherProvider();

  // Future<WeatherModel> fetchWeather(lat, lon) {
  //   return weatherProvider.fetchWeather(lat, lon); 
  // }

  Stream<WindModel> getWindStream() => windProvider.wind.stream;
  Stream<PositionModel> getPositionStream() => positionProvider.position;

  // Future<ItemModel> fetchAllMovies() => moviesApiProvider.fetchMovieList();
}