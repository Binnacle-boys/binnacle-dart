import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/weather_model.dart';

class WeatherProvider {
  Client client = Client();
  final _apiKey = "80823ccc590c29c76f3094869dcdbee9";
  final _apiURL = "https://api.openweathermap.org/data/2.5/weather";

  Future<WeatherModel> fetchWeather(String lat, String lon) async {
    print("fetching weather....");
    print(lat + ' ' + lon);
    final response = await client
        .get((_apiURL 
          + "?lat=" + lat 
          + "&lon=" + lon 
          + "&APPID="+_apiKey
        ));

    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load weather');
    }
  }
}