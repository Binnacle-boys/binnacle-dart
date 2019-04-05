import 'dart:async';
import './providers/position_provider.dart';
import 'models/position_model.dart';
// import 'movie_api_provider.dart';
// import '../models/item_model.dart';

class Repository {
  // final moviesApiProvider = MovieApiProvider();
  final positionProvider = PositionProvider();

  Stream<PositionModel> getPositionStream() => positionProvider.position;

  // Future<ItemModel> fetchAllMovies() => moviesApiProvider.fetchMovieList();
}