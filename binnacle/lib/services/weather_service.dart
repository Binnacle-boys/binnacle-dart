import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:rxdart/rxdart.dart';

import '../models/weather_model.dart';
import '../models/position_model.dart';
import '../models/wind_model.dart';
import '../providers/wind_provider.dart';

class WeatherService extends IWindService {
  Client client = Client();
  final _apiKey = "80823ccc590c29c76f3094869dcdbee9";
  final _apiURL = "https://api.openweathermap.org/data/2.5/weather";
  var _windStream = StreamController<WindModel>();
  BehaviorSubject<PositionModel> _position;

  WeatherService(BehaviorSubject<PositionModel> position) {
    this._position = position;

    fetchWeather(_position);
  }
  Future<PositionModel> lastNonNull(Stream<PositionModel> stream) =>
      stream.firstWhere((x) => x != null);

  void fetchWeather(BehaviorSubject<PositionModel> positionStream) async {
    PositionModel position = await lastNonNull(positionStream);
    print("___ pos const: " + position.lat.toString());
    print("fetching weather....");
    print(position.lat.toString() + ' ' + position.lon.toString());
    final response = await client.get((_apiURL +
        "?lat=" +
        position.lat.toString() +
        "&lon=" +
        position.lon.toString() +
        "&APPID=" +
        _apiKey));

    print(response.body.toString());
    if (response.statusCode == 200) {
      // TODO remove this debugging code
      // If the call to the server was successful, parse the JSON
      var temp = WeatherModel.fromJson(json.decode(response.body));
      WindModel wind = WindModel(temp.wind.speed, temp.wind.deg);
      print("Temp:" + temp.toString());
      print(temp.wind.speed.toString() + "   " + temp.wind.deg.toString());
      _windStream.sink.add(wind);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load weather');
    }
  }

  StreamController<WindModel> get windStream => _windStream;
}
