import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' show Client;
import 'package:rxdart/rxdart.dart';

import 'package:sos/models/weather_model.dart';
import 'package:sos/models/position_model.dart';
import 'package:sos/models/wind_model.dart';
import 'package:sos/models/wind_service_interface.dart';
import 'package:sos/models/service_data.dart';
import 'package:sos/services/service_wrapper_interface.dart';

class WeatherService extends IWindService {
  StreamController<WindModel> get windStream => _windStream;

  /// TODO: move apikey and url to some env file
  Client _client;
  final _apiKey = "80823ccc590c29c76f3094869dcdbee9";
  final _apiURL = "https://api.openweathermap.org/data/2.5/weather";

  StreamController<WindModel> _windStream;
  BehaviorSubject<PositionModel> _position;
  final ServiceData serviceData = ServiceData('wind', 'name', 1);

  WeatherService(this._position) {
    _client = Client();
    _windStream = StreamController();

    fetchWeather(_position);
  }

  /// BUG: This should be last so it gets the latest position value,
  /// but isn't being used like that.
  Future<PositionModel> lastNonNull(Stream<PositionModel> stream) =>
      stream.firstWhere((x) => x != null);

  /// Calls OpenWeatherMap to retrieve a WindModel
  /// If successful, will call again in 10 minutes.
  /// Otherwise it will try again in 10 seconds.
  void fetchWeather(BehaviorSubject<PositionModel> positionStream) async {
    var position = await lastNonNull(positionStream);

    print("___ pos const: " + position.lat.toString());
    print("fetching weather....");
    print(position.lat.toString() + ' ' + position.lon.toString());

    var response;
    try {
      response = await _client.get((_apiURL +
          "?lat=" +
          position.lat.toString() +
          "&lon=" +
          position.lon.toString() +
          "&APPID=" +
          _apiKey));
    } on SocketException {
      print('There was no internet to be had...');
    }

    if (response.statusCode == 200) {
      // TODO add error throwing code
      var temp = WeatherModel.fromJson(json.decode(response.body));
      WindModel wind = WindModel(temp.wind.speed, temp.wind.deg);
      _windStream.sink.add(wind);

      print('Will request again in 10 minutes');
      Future.delayed(new Duration(seconds: 600), () {
        fetchWeather(_position);
      });
    } else {
      print('OpenWeatherMap failed to respond');
      print('Will try again in 10 seconds');
      Future.delayed(new Duration(seconds: 10), () {
        fetchWeather(_position);
      });
    }
  }

  dispose() async {
    /// NOTE: No subscription here like in other services

    await _windStream.close();
    _client.close();
  }
}

class WeatherServiceWrapper implements ServiceWrapper {
  get service => WeatherService(_positionStream);
  ServiceData get serviceData => this._serviceData;
  bool get isDefault => this._default;

  final ServiceData _serviceData = ServiceData('wind', 'open weather maps', 1);
  final bool _default = true;
  final _positionStream;

  WeatherServiceWrapper(this._positionStream);
}
