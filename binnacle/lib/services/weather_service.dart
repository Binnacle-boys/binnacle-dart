import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:rxdart/rxdart.dart';

import '../models/weather_model.dart';
import '../models/position_model.dart';
import '../models/wind_model.dart';
import '../models/wind_service_interface.dart';
import '../models/service_data.dart';
import './service_wrapper_interface.dart';

class WeatherService extends IWindService {
  Client client = Client();
  final _apiKey = "80823ccc590c29c76f3094869dcdbee9";
  final _apiURL = "https://api.openweathermap.org/data/2.5/weather";
  var _windStream = StreamController<WindModel>();
  BehaviorSubject<PositionModel> _position;
  final ServiceData serviceData = ServiceData('wind', 'name', 1);

  WeatherService(BehaviorSubject<PositionModel> position) {
    this._position = position;

    fetchWeather(_position);
  }
  Future<PositionModel> lastNonNull(Stream<PositionModel> stream) =>
      stream.firstWhere((x) => x != null);

  void fetchWeather(BehaviorSubject<PositionModel> positionStream) async {
    var position;
    try {
      position = await lastNonNull(positionStream);
    } catch (e) {
      print(e);
      print(
          "From weather_service: If you aren't in the ios simulator, location is messing up and threw this ^^^");
      position = new PositionModel(lat: 0.0, lon: 0.0, speed: 0.0);
    }
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

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var temp = WeatherModel.fromJson(json.decode(response.body));
      WindModel wind = WindModel(temp.wind.speed, temp.wind.deg);
      _windStream.sink.add(wind);
    } else {
      print('Did not get a 200 response from OpenWeatherMaps. Requesting Weather Data again');
      fetchWeather(_position);
    }
  }

    dispose() async {
    //! there's no subscibtion here like there are in other services
    //! consider starting debug here if issue arises
    // await _subscription.pause(); 
    await _windStream.close();

  }

  StreamController<WindModel> get windStream => _windStream;
}

class WeatherServiceWrapper implements ServiceWrapper{
  final ServiceData _serviceData = ServiceData('wind', 'open weather maps', 1);
  final bool _default = true;
  final _positionStream;

  WeatherServiceWrapper(this._positionStream);

  get service =>  WeatherService(_positionStream);
  ServiceData get serviceData => this._serviceData;
  bool get isDefault => this._default;

}