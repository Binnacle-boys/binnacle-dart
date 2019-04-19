import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:rxdart/rxdart.dart';

import '../models/weather_model.dart';
import '../models/position_model.dart';
import '../models/wind_model.dart';
import '../providers/wind_provider.dart';
import '../models/service_data.dart';

class WeatherService extends IWindService {
  Client client = Client();
  final _apiKey = "80823ccc590c29c76f3094869dcdbee9";
  final _apiURL = "https://api.openweathermap.org/data/2.5/weather";
  var _windStream = StreamController<WindModel>();
  BehaviorSubject<PositionModel> _position;
  final ServiceData serviceData = ServiceData('wind', 'name', 1);

  WeatherService(BehaviorSubject<PositionModel> position) {
    this._position = position;
    fetchWeather(_position.value);
  }

  void fetchWeather(PositionModel position) async {
    final response = await client
        .get((_apiURL 
          + "?lat=" + position.lat.toString()
          + "&lon=" + position.lon.toString() 
          + "&APPID="+ _apiKey
        ));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var temp = WeatherModel.fromJson(json.decode(response.body));
      WindModel wind = WindModel(temp.wind.speed, temp.wind.deg);
      _windStream.sink.add(wind);
    } else {
      // If that call was not successful, throw an error.
      // !TODO  Don't throw the error. Add the error into the stream
      print("RESPONSE status code: " +
          response.statusCode.toString() +
          " RESPONSE BODY:  " +
          response.body.toString());
      //throw Exception('Failed to load weather');
    }
  }

  StreamController<WindModel> get windStream => _windStream;
}
