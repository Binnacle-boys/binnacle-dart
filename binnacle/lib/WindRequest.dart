import 'package:http/http.dart' as http;
import 'dart:convert';

class WindRequest {
  final Wind wind;

  WindRequest({this.wind});

  factory WindRequest.fromJson(Map<String, dynamic> json) {
    print("WindJson: "+json['wind'].toString());
    return WindRequest(
      wind: Wind.fromJson(json['wind'])
    );
  }
}

class Wind{
  double speed;
  int heading;

  Wind({
    this.speed,
    this.heading
});

  factory Wind.fromJson(Map<String, dynamic> json2){
    return Wind(
      speed: json2['speed'],
      heading: json2['deg']
    );
  }
}

Future<WindRequest> fetchWind(double lat, double lon) async {
  final response = await http.get('https://api.openweathermap.org/data/2.5/weather?lat='+lat.toString()+'&lon='+lon.toString()+'&APPID=80823ccc590c29c76f3094869dcdbee9');

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    print("Wind API Response:" + response.body);
    return WindRequest.fromJson(json.decode(response.body));
  }
  else {
    // If that response was not OK, throw an error.
    print("Response error: "+response.body);
    throw Exception('Failed to load post');
  }
}