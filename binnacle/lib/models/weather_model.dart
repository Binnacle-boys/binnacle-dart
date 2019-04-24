
/*
* This class models the http response from open weather maps. 
* All names map to the response name. They are private because they are 
* totally irrelevent to anyone outside this class.
*/
class WeatherModel {
  _Coord _coord;
  _Sys _sys;
  _Main _main;
  _Wind _wind;
  _Clouds _clouds;
  int _dt;
  int _id;
  String _name;
  int _cod;

  WeatherModel.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    _coord = _Coord.fromJson(json['coord']);
    _sys = _Sys.fromJson(json['sys']);
    _main = _Main.fromJson(json['main']);
    _wind = _Wind.fromJson(json['wind']);
    _clouds = _Clouds.fromJson(json['clouds']);
    _dt = json['dt'];
    _id = json['id'];
    _name = json['name'];
    _cod = json['cod'];
  }
  _Coord get coord => _coord;
  _Sys get sys => _sys;
  _Main get main => _main;
  _Wind get wind => _wind;
  _Clouds get clouds => _clouds;
  int get dt => _dt;
  int get id => _id;
  String get name => _name;
  int get cod => _cod;
}

class _Coord {
  double lat;
  double lon;
  _Coord({this.lat, this.lon});

  factory _Coord.fromJson(Map<String, dynamic> json) {
    return _Coord(lat: json['lat'].toDouble(), lon: json['lon'].toDouble());
  }
}

class _Sys {
  String country;
  int type;
  int id;
  double message;
  int sunrise;
  int sunset;

  _Sys(
      {this.country,
      this.type,
      this.id,
      this.message,
      this.sunrise,
      this.sunset});

  factory _Sys.fromJson(Map<String, dynamic> json) {
    return _Sys(
        country: json['country'],
        type: json['type'],
        id: json['id'],
        message: json['message'],
        sunrise: json['sunrise'],
        sunset: json['sunset']);
  }
}

class _Main {
  double temp;
  double pressure;
  int humidity;
  double temp_min;
  double temp_max;

  _Main(
      {this.temp, this.pressure, this.humidity, this.temp_max, this.temp_min});
  factory _Main.fromJson(Map<String, dynamic> json) {
    return _Main(
        temp: json['temp'].toDouble(),
        pressure: json['pressure'].toDouble(),
        humidity: json['humidity'],
        temp_max: json['temp_max'],
        temp_min: json['temp_min']);
  }
}

class _Wind {
  double speed;
  double deg;

  _Wind({this.speed, this.deg});

  factory _Wind.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('deg') && json.containsKey('speed')) {
      return _Wind(speed: json['speed'], deg: json['deg'].toDouble());
    } else {
      print(
        //TODO Handle this case better
          "No wind degree provided, this isnt good but I'm just  defaulting to 0.0");
      return _Wind(speed: json['speed'], deg: 0.0);
    }
  }
}

class _Clouds {
  int all;
  _Clouds({this.all});

  factory _Clouds.fromJson(Map<String, dynamic> json) {
    return _Clouds(all: json['all']);
  }
}
