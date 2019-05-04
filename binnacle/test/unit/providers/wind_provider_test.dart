import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sos/models/position_model.dart';
import 'package:sos/models/wind_model.dart';
import 'package:sos/providers/wind_provider.dart';
import 'package:sos/services/open_weather_service.dart';
import 'package:sos/services/service_list.dart';

void main() {
  WindProvider _provider;
  PublishSubject _activeServiceWrapper = PublishSubject();
  StreamController<WindModel> _windStreamWrapper = StreamController();
  BehaviorSubject<PositionModel> _positionStream = BehaviorSubject(
      seedValue: PositionModel(lat: 30.0, lon: 121.0, speed: 0.6));

  setUp(() async {
    ServiceList _serviceList = ServiceList('compass', [
      WeatherServiceWrapper(_positionStream.stream),
    ]);
    _provider = await WindProvider(_serviceList);
    _provider.activeService.stream.listen((data) {
      _activeServiceWrapper.add(data);
    });

    _provider.wind.stream.listen((data) {
      _windStreamWrapper.add(data);
    });
  });

  test('Wind provider initialized', () async {
    expect(_provider.runtimeType, WindProvider);
    await expectLater(await _activeServiceWrapper.isEmpty, false);
  });
}
