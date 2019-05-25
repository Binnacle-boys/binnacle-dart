import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:sos/providers/navigation_provider.dart';
import 'package:sail_routing_dart/polar_plotting/polar_plot.dart';
import 'package:sos/services/bluetooth_compass_service.dart';
import 'package:sos/services/bluetooth_list_angle_service.dart';
import 'package:sos/services/bluetooth_position_service.dart';
import 'package:sos/services/bluetooth_wind_service.dart';
import 'package:sos/services/compass_service.dart';
import 'package:sos/models/list_angle_model.dart';
import 'package:sos/providers/list_angle_provider.dart';
import 'package:sos/providers/position_provider.dart';
import 'package:sos/providers/wind_provider.dart';
import 'package:sos/providers/compass_provider.dart';

import 'package:sos/services/list_angle_service.dart';
import 'package:sos/services/geolocation_service.dart';
import 'package:sos/services/open_weather_service.dart';
import 'package:sos/services/test_compass_service.dart';
import 'package:sos/services/service_list.dart';

import 'package:sos/models/position_model.dart';
import 'package:sos/models/compass_model.dart';
import 'package:sos/models/wind_model.dart';
import 'package:sos/models/service_data.dart';
import 'package:sos/models/provider_data.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import "providers/bluetooth.dart";
import "enums.dart";

import "dummy_bt_stream.dart"; //TODO: Remove this when we can actually connect to BT device

class Repository {
  /// Data points
  Stream<WindModel> get wind => _windProvider.wind.stream;
  Stream<PositionModel> get position => _positionProvider.position.stream;
  Stream<CompassModel> get compass => _compassProvider.compass.stream;
  Stream<List<ServiceData>> get activeServices => _activeServices.stream;
  Stream<ListAngleModel> get listAngle => _listAngleProvider.listAngle.stream;

  Stream<List<ServiceList>> get availableServices => _availableServices;
  Stream<List<ProviderData>> get providerData => _providerData.stream;

  //bluetooth
  StreamController<bool> isScanning() => _isScanning;
  StreamController scanResults() => _scanResults;

  NavigationProvider navigator;

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

  

  BluetoothManager bluetooth;
  StreamController<bool> _isScanning = StreamController();
  StreamController _scanResults = StreamController();

  Map<ProviderType, ServiceList> _serviceListMap = Map();
  Map<ProviderType, dynamic> _providerMap = Map();
  Map _bluetoothServiceMap = Map();

  Repository(BehaviorSubject<PositionModel> positionStream) {
    compassServiceList = ServiceList(ProviderType.compass,
        [CompassServiceWrapper(), MockCompassServiceWrapper(false)]);
    windServiceList =
        ServiceList(ProviderType.wind, [WeatherServiceWrapper(positionStream)]);
    positionServiceList =
        ServiceList(ProviderType.position, [GeolocationServiceWrapper()]);
    listAngleServiceList =
        ServiceList(ProviderType.list_angle, [ListAngleServiceWrapper()]);

    this._positionProvider = PositionProvider(positionServiceList);
    this._compassProvider = CompassProvider(compassServiceList);
    this._windProvider = WindProvider(windServiceList);
    this._listAngleProvider = ListAngleProvider(listAngleServiceList);

    _serviceListMap = {
      ProviderType.compass: compassServiceList,
      ProviderType.wind: windServiceList,
      ProviderType.position: positionServiceList,
      ProviderType.list_angle: listAngleServiceList
    };
    _providerMap = {
      ProviderType.compass: _compassProvider,
      ProviderType.wind: _windProvider,
      ProviderType.position: _positionProvider,
      ProviderType.list_angle: _listAngleProvider
    };

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

    bluetooth = BluetoothManager();

    _isScanning.addStream(bluetooth.isScanning.stream);
    _scanResults.addStream(bluetooth.scanResults.stream);
    bluetooth.isConnected.stream.listen((data) {
      (data) ? _addBluetoothServices() : _removeBluetoothServices();
    });

    _setUpNavigationProvider(positionStream);
    
    
    
  }
  _addBluetoothServices() {
    var bt =
        DummyBT(); //TODO: Remove this when we can actually connect to a BT device

    _bluetoothServiceMap = {
      ProviderType.compass:
          BluetoothCompassServiceWrapper(bluetooth: bt.btStream),
      ProviderType.wind: BluetoothWindServiceWrapper(bluetooth: bt.btStream),
      ProviderType.position:
          BluetoothPositionServiceWrapper(bluetooth: bt.btStream),
      ProviderType.list_angle:
          BluetoothListAngleServiceWrapper(bluetooth: bt.btStream)
    };

    ProviderType.values.forEach(
        (value) => _serviceListMap[value].add(_bluetoothServiceMap[value]));
  }

  _removeBluetoothServices() {
    ProviderType.values.forEach(
        (value) => _serviceListMap[value].remove(_bluetoothServiceMap[value]));
    _bluetoothServiceMap = {};
  }

  toggleMode(ProviderData providerData) {
    _providerMap[providerData.type].toggleMode(providerData);
  }

  setActiveService(ServiceData serviceData) {
    _providerMap[serviceData.category].changeService(serviceData);
  }

  void _setUpNavigationProvider(BehaviorSubject<PositionModel> positionStream) {
    navigator = NavigationProvider(
      position: positionStream,
      wind: _windProvider.wind);
  } 
}
