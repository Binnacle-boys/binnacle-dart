import '../Wind.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class PhoneWind extends Wind {
  Timer requestTimer;
  Timer fallbackTimer;
  Stream<Position> positionStream;

  PhoneWind(Stream<Position> this.positionStream) {
    setRequestTimer();
  }

  void setRequestTimer() {
    requestTimer = Timer.periodic(Duration(minutes: 10), requestCallback);
  }

  void setFallbackTimer(int length) {
    fallbackTimer = Timer.periodic(Duration(seconds: length), requestCallback);
  }

  void requestCallback(Timer timer) {
    positionStream.last.then(fetchWind);
  }

  fetchWind(Position location) async {
    /// Check if the last known location from the locationStream is null.
    if (location == null) {
      /// If the location is null, check if the original timer is still active.
      /// If so, cancel it and start the fallback timer, which checks more
      /// frequently.
      if (requestTimer.isActive) {
        requestTimer.cancel();
        setFallbackTimer(1);
      }

      /// Else, we still don't have a valid location but the fallback is already
      /// set, so return without doing anything
      else {
        return;
      }
    }

    /// Else, we must have a valid last known position
    else {
      String lat = location.latitude.toString();
      String lon = location.longitude.toString();
      final response = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?lat=' +
              lat +
              '&lon=' +
              lon +
              '&APPID=80823ccc590c29c76f3094869dcdbee9');

      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        print("Wind API Response:" + response.body);
//        return WindRequest.fromJson(json.decode(response.body));
      } else {
        /// If the request times out or the server returns an error, start the
        /// fallback timer with a longer duration (network requests are
        /// resource intensive)
        print("Response error: " + response.body);
        setFallbackTimer(60);
//        throw Exception('Failed to load post');
      }
    }
  }
}
