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
import './services/service_wrapper_interface.dart';

import 'models/position_model.dart';
import 'models/compass_model.dart';
import 'models/wind_model.dart';
import 'models/service_data.dart';
import 'models/provider_data.dart';

class ServiceList {

  final String type;
  List <ServiceWrapper> _list; 
  ServiceList(this.type, this._list);
  List<ServiceWrapper> get serviceList => _list;
  
  //TODO type this function
  dynamic service(ServiceData data) => _list.firstWhere((wrapper) => 
    identical(wrapper.serviceData, data));

  ServiceWrapper get defaultService => _list.firstWhere((wrapper) => 
    wrapper.isDefault == true);

  ServiceWrapper nextPriority(ServiceData serviceData) => 
    _list.firstWhere((wrapper) => 
      ((wrapper.serviceData.priority > serviceData.priority)  
      && !identical(serviceData, wrapper.serviceData)));

}

class Repository {
  PositionProvider _positionProvider;
  WindProvider _windProvider;
  CompassProvider _compassProvider;
  ListAngleProvider _listAngleProvider;


  StreamController<List<ServiceData>> _activeServices = StreamController();


  BehaviorSubject<List<ServiceList>> _availableServices = BehaviorSubject();


  ServiceList compassServiceList;
  ServiceList windServiceList;
  ServiceList positionServiceList;
  ServiceList listAngleServiceList;


  BehaviorSubject _providerData = BehaviorSubject();


  Repository(BehaviorSubject<PositionModel> positionStream) {
    
    compassServiceList = ServiceList('compass',[CompassServiceWrapper(), MockCompassServiceWrapper()]);
    windServiceList = ServiceList('wind', [WeatherServiceWrapper(positionStream)]);
    positionServiceList = ServiceList('position', [GeolocationServiceWrapper()]);
    listAngleServiceList = ServiceList('list angle', [ListAngleServiceWrapper()] );

    
    this._positionProvider = PositionProvider( positionServiceList);
    this._compassProvider = CompassProvider( compassServiceList);

    this._windProvider = WindProvider( windServiceList);
    this._listAngleProvider = ListAngleProvider(listAngleServiceList);


    // _activeServices = _activeServices.mergeWith([      
    //   _compassProvider.activeService.stream,
    //   _positionProvider.activeService.stream]);

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
    if (providerData.type == "compass") {
      _compassProvider.toggleMode(providerData);
    }
    if (providerData.type == "position") {
      _positionProvider.toggleMode(providerData);
    }
    if (providerData.type == "wind") {
      _windProvider.toggleMode(providerData);
    }
    if (providerData.type == "list angle") {
      _listAngleProvider.toggleMode(providerData);
    }
  }

  setActiveService(ServiceData serviceData) {
    if (serviceData.serviceCategory == "compass") {
      _compassProvider.changeService(serviceData);
    }
    if (serviceData.serviceCategory == "position") {
      _positionProvider.changeService(serviceData);
    }
    if (serviceData.serviceCategory == "wind") {
      _windProvider.changeService(serviceData);
    }
    if (serviceData.serviceCategory == "list angle") {
      _listAngleProvider.changeService(serviceData);
    }
  }


  Stream<WindModel> getWindStream() => _windProvider.wind.stream;
  Stream<PositionModel> getPositionStream() => _positionProvider.position.stream;
  Stream<CompassModel> getCompassStream() => _compassProvider.compass.stream;
  Stream<List<ServiceData>> getActiveServices() => _activeServices.stream;

  Stream <List<ServiceList>> getAvailableServices() => _availableServices;
  Stream getProviderData() => _providerData.stream;
  Stream<ListAngleModel> getListAngleStream() => _listAngleProvider.listAngle.stream;
}
