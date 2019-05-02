import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:sos/services/compass_service.dart';
import 'package:sos/models/list_angle_model.dart';
import 'package:sos/providers/list_angle_provider.dart';
import 'package:sos/services/list_angle_service.dart';

import './providers/position_provider.dart';
import './providers/wind_provider.dart';
import './providers/compass_provider.dart';

import './services/geolocation_service.dart';
import './services/weather_service.dart';
import './services/test_compass_service.dart';
import './services/service_list.dart';

import 'models/position_model.dart';
import 'models/compass_model.dart';
import 'models/wind_model.dart';
import 'models/service_data.dart';
import 'models/provider_data.dart';

import "providers/bluetooth.dart";
import "enums.dart";



class Repository {
  PositionProvider _positionProvider;
  WindProvider _windProvider;
  CompassProvider _compassProvider;
  ListAngleProvider _listAngleProvider;
  
  StreamController<List<ServiceData>> _activeServices = StreamController();
  BehaviorSubject<List<ServiceList>> _availableServices = BehaviorSubject();
  BehaviorSubject<List<ProviderData>> _providerData = BehaviorSubject();

  ServiceList compassServiceList;
  ServiceList windServiceList;
  ServiceList positionServiceList;
  ServiceList listAngleServiceList;
  
  BluetoothManager bluetooth;
  StreamController<bool> _isScanning = StreamController();
  StreamController _scanResults = StreamController();

  Map<ProviderType, ServiceList> _serviceListMap = Map();
  Map<ProviderType, dynamic> _providerMap = Map();
  Repository(BehaviorSubject<PositionModel> positionStream) {
    
    compassServiceList = ServiceList(ProviderType.compass,[CompassServiceWrapper(), MockCompassServiceWrapper(false)]);
    windServiceList = ServiceList(ProviderType.wind, [WeatherServiceWrapper(positionStream)]);
    positionServiceList = ServiceList(ProviderType.position, [GeolocationServiceWrapper()]);
    listAngleServiceList = ServiceList(ProviderType.list_angle, [ListAngleServiceWrapper()] );

    
    this._positionProvider = PositionProvider( positionServiceList);
    this._compassProvider = CompassProvider( compassServiceList);

    this._windProvider = WindProvider( windServiceList);
    this._listAngleProvider = ListAngleProvider(listAngleServiceList);


   _serviceListMap =  {
    ProviderType.compass: compassServiceList, 
    ProviderType.wind: windServiceList,
    ProviderType.position: positionServiceList,
    ProviderType.list_angle: listAngleServiceList
  };
    _providerMap =  {
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
  }
  _addBluetoothServices() {
    //TODO write the bluetooth services.
  }
  _removeBluetoothServices() {

  }

  toggleMode(ProviderData providerData) {
    _providerMap[providerData.type].toggleMode(providerData);

  //   switch(providerData.type) { 
  //     case "compass": { 
  //       _compassProvider.toggleMode(providerData);

  //     } 
  //     break; 
  //     case "position": { 
  //       _positionProvider.toggleMode(providerData);
  //     } 
  //     break; 
  //     case "wind": { 
  //       _windProvider.toggleMode(providerData);
  //     }
  //     break;
  //     case "list angle": {
  //       _listAngleProvider.toggleMode(providerData);
  //     }
  //     break; 
  //     default: {
  //       return;
  //     }
  // }
}

  setActiveService(ServiceData serviceData) {
    _providerMap[serviceData.category].changeService(serviceData);


// switch(serviceData.category) { 
//       case "compass": { 
//         _compassProvider.changeService(serviceData);

//       } 
//       break; 
//       case "position": { 
//         _positionProvider.changeService(serviceData);
//       } 
//       break; 
//       case "wind": { 
//         _windProvider.changeService(serviceData);
//       }
//       break;
//       case "list angle": {
//         _listAngleProvider.changeService(serviceData);
//       }
//       break; 
//       default: {
//         return;
//       }
//    }
  }

  Stream<WindModel> getWindStream() => _windProvider.wind.stream;
  Stream<PositionModel> getPositionStream() => _positionProvider.position.stream;
  Stream<CompassModel> getCompassStream() => _compassProvider.compass.stream;
  Stream<List<ServiceData>> getActiveServices() => _activeServices.stream;

  Stream <List<ServiceList>> getAvailableServices() => _availableServices;
  Stream <List<ProviderData>> getProviderData() => _providerData.stream;
  Stream<ListAngleModel> getListAngleStream() => _listAngleProvider.listAngle.stream;


  StreamController<bool> isScanning() => _isScanning;
  StreamController scanResults() => _scanResults;

}
