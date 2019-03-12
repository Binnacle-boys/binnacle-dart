import '../Wind.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:convert';

class PhoneWind extends Wind {
  static final PhoneWind instance = new PhoneWind._internal();
  Timer requestTimer;
  Timer fallbackTimer;

  factory PhoneWind(){
    return instance;
  }

  PhoneWind._internal(){
    requestTimer = Timer.periodic(Duration(days:99), requestCallback);
    requestTimer.cancel();
    fallbackTimer = Timer.periodic(Duration(seconds: 1), requestCallback);
  }

  void setRequestTimer(){
    if(fallbackTimer.isActive) fallbackTimer.cancel();
    requestTimer = Timer.periodic(Duration(minutes: 10), requestCallback);
  }

  void setFallbackTimer(int length){
    if(requestTimer.isActive) requestTimer.cancel();
    fallbackTimer = Timer.periodic(Duration(seconds: length), requestCallback);
  }

  /// This callback is triggered every time a Timer completes and makes a
  /// request to the Wind API endpoint
  void requestCallback(Timer timer){
    print("requestCallback triggered, attempting to fetch wind.");
    Geolocator().getLastKnownPosition().then(fetchWind);
  }

  fetchWind(Position position) async {
    print("Fetching wind.");
    /// Check if the last known location from the locationStream is null.
    if(position == null){
      /// If the position is null, check if the original timer is still active.
      /// If so, cancel it and start the fallback timer, which checks more
      /// frequently (every second, until we get a GPS lock)
      if(requestTimer.isActive){
        print("Position null and requestTimer running, switching to fallbackTimer.");
        setFallbackTimer(1);
      }
      /// Else, we still don't have a valid position but the fallback is already
      /// set, so return without doing anything
      else{
        print("Position null and fallbackTimer already running.");
        return;
      }
    }

    /// Else, we must have a valid last known position
    else{
      print("Valid position detected, making network request.");
      String lat = position.latitude.toString();
      String lon = position.longitude.toString();
      final response = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?lat='
          +lat+'&lon='+lon+'&APPID=80823ccc590c29c76f3094869dcdbee9');

      if (response.statusCode == 200) {
        /// If server returns an OK response, parse the JSON
        print("Wind API Response:" + response.body);


        /// Return data, if fallback timer running cancel and start requestTimer
        setRequestTimer();
        WindResponse parsedResponse = WindResponse.fromJson(json.decode(response.body));
        double speedVal = double.parse(parsedResponse.windResponseComponent.speed);
        double headingVal = double.parse(parsedResponse.windResponseComponent.heading);
        speed.add(speedVal);
        direction.add(headingVal);
        print("Wind speed and heading added to stream.");
      }
      else {
        /// If the request times out or the server returns an error, start the
        /// fallback timer with a longer duration (every minute; network
        /// requests are resource intensive)
        print("Response error: "+response.body);
        setFallbackTimer(60);
      }
    }
  }
}

class WindResponse{
  final WindResponseComponent windResponseComponent;

  WindResponse({this.windResponseComponent});

  factory WindResponse.fromJson(Map<String, dynamic> json){
    print("Response JSON object: "+json['wind'].toString());
    return WindResponse(
      windResponseComponent: WindResponseComponent.fromJson(json['wind'])
    );
  }
}

class WindResponseComponent{
  String speed;
  String heading;

  WindResponseComponent({
    this.speed,
    this.heading
  });

  factory WindResponseComponent.fromJson(Map<String, dynamic> json2){
    return WindResponseComponent(
        speed: json2['speed'].toString(),
        heading: json2['deg'].toString()
    );
  }
}