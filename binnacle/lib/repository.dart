import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:sos/providers/list_angle_provider.dart';
import 'package:sos/providers/position_provider.dart';
import 'package:sos/providers/wind_provider.dart';
import 'package:sos/providers/compass_provider.dart';

import 'package:sos/services/list_angle_service.dart';
import 'package:sos/services/compass_service.dart';
import 'package:sos/services/geolocation_service.dart';
import 'package:sos/services/open_weather_service.dart';
import 'package:sos/services/test_compass_service.dart';
import 'package:sos/services/service_list.dart';

import 'package:sos/models/list_angle_model.dart';
import 'package:sos/models/position_model.dart';
import 'package:sos/models/compass_model.dart';
import 'package:sos/models/wind_model.dart';
import 'package:sos/models/service_data.dart';
import 'package:sos/models/provider_data.dart';

class Repository {
  /// Data points
  Stream<WindModel> get wind => _windProvider.wind.stream;
  Stream<PositionModel> get position => _positionProvider.position.stream;
  Stream<CompassModel> get compass => _compassProvider.compass.stream;
  Stream<List<ServiceData>> get activeServices => _activeServices.stream;
  Stream<ListAngleModel> get listAngle => _listAngleProvider.listAngle.stream;

  Stream<List<ServiceList>> get availableServices => _availableServices;
  Stream<List<ProviderData>> get providerData => _providerData.stream;

  ServiceList compassServiceList;
  ServiceList windServiceList;
  ServiceList positionServiceList;
  ServiceList listAngleServiceList;

  PositionProvider _positionProvider;
  WindProvider _windProvider;
  CompassProvider _compassProvider;
  ListAngleProvider _listAngleProvider;

  StreamController<List<ServiceData>> _activeServices = StreamController();
  BehaviorSubject<List<ServiceList>> _availableServices = BehaviorSubject();
  BehaviorSubject<List<ProviderData>> _providerData = BehaviorSubject();

  Repository(BehaviorSubject<PositionModel> positionStream) {
    compassServiceList = ServiceList(
        'compass', [CompassServiceWrapper(), MockCompassServiceWrapper(false)]);
    windServiceList =
        ServiceList('wind', [WeatherServiceWrapper(positionStream)]);
    positionServiceList =
        ServiceList('position', [GeolocationServiceWrapper()]);
    listAngleServiceList =
        ServiceList('list angle', [ListAngleServiceWrapper()]);

    this._positionProvider = PositionProvider(positionServiceList);
    this._compassProvider = CompassProvider(compassServiceList);

    this._windProvider = WindProvider(windServiceList);
    this._listAngleProvider = ListAngleProvider(listAngleServiceList);

    _availableServices.addStream(CombineLatestStream.list([
      _compassProvider.availableServices.stream,
      _positionProvider.availableServices.stream,
      _windProvider.availableServices.stream,
      _listAngleProvider.availableServices.stream
    ]));

    _activeServices.addStream(CombineLatestStream.list([
      _compassProvider.activeService.stream,
      _positionProvider.activeService.stream,
      _windProvider.activeService.stream,
      _listAngleProvider.activeService.stream,
    ]));

    _providerData.addStream(CombineLatestStream.list([
      _compassProvider.providerData.stream,
      _positionProvider.providerData.stream,
      _windProvider.providerData.stream,
      _listAngleProvider.providerData.stream
    ]));
  }

  toggleMode(ProviderData providerData) {
    switch (providerData.type) {
      case "compass":
        _compassProvider.toggleMode(providerData);
        break;
      case "position":
        _positionProvider.toggleMode(providerData);
        break;
      case "wind":
        _windProvider.toggleMode(providerData);
        break;
      case "list angle":
        _listAngleProvider.toggleMode(providerData);
        break;
      default:
        throw new Exception('Failed to find $providerData');
    }
  }

  setActiveService(ServiceData serviceData) {
    switch (serviceData.category) {
      case "compass":
        _compassProvider.changeService(serviceData);
        break;
      case "position":
        _positionProvider.changeService(serviceData);
        break;
      case "wind":
        _windProvider.changeService(serviceData);
        break;
      case "list angle":
        _listAngleProvider.changeService(serviceData);
        break;
      default:
        throw new Exception('Failed to find $serviceData');
    }
  }
}
