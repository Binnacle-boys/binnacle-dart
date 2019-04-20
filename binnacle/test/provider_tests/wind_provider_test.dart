// import 'package:flutter_test/flutter_test.dart';
// import 'package:rxdart/rxdart.dart';

// import 'package:sos/providers/wind_provider.dart';
// import 'package:sos/services/weather_service.dart';
// import 'package:sos/models/position_model.dart';

// void main() {
//   WindProvider _provider;
//   IWindService _service;
//   PositionModel _position = new PositionModel(lat: 1.0, lon: 1.0, speed: 1.0);
//   BehaviorSubject<PositionModel> _positionStream = BehaviorSubject();

//   setUp(() {
//     _positionStream.sink.add(_position);
//     _service = WeatherService(_positionStream);
//     _provider = WindProvider(service: _service);
//   });

//   test('compass provider is initialized', () {
//     expect(_provider.runtimeType, WindProvider);
//   });
// }
