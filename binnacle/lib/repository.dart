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

  StreamController<ServiceData> _activeServices = StreamController();
  StreamController<ServiceList> _availableServices = StreamController();
  StreamController<List<ServiceList>> _providerTypes = StreamController();
  ServiceList compassServiceList;
  ServiceList windServiceList;
  ServiceList positionServiceList;


  BehaviorSubject _providerData = BehaviorSubject();


  Repository(BehaviorSubject<PositionModel> positionStream) {
    
    compassServiceList = ServiceList('compass',[CompassServiceWrapper(), MockCompassServiceWrapper()]);
    windServiceList = ServiceList('wind', []);
    positionServiceList = ServiceList('position', []);

    _providerTypes.sink.add([compassServiceList, windServiceList, positionServiceList]);
    
    this._positionProvider = PositionProvider( service: new GeolocationService() );
    this._windProvider = WindProvider( service: new WeatherService(positionStream) );
    this._listAngleProvider = ListAngleProvider(service: new ListAngleService());
    this._compassProvider = CompassProvider(compassServiceList);


    _availableServices.sink.addStream(_compassProvider.availableServices.stream);
    _activeServices.addStream(_compassProvider.activeService.stream);


    _providerData.addStream(CombineLatestStream.list([
      _compassProvider.providerData.stream, 
      _positionProvider.providerData.stream
      ]
      ),
    );
  }

  toggleMode(ProviderData providerData) {
        if (providerData.type == "compass") {
      _compassProvider.toggleMode(providerData);
    }
  }

  setActiveService(ServiceData serviceData) {
    if (serviceData.serviceCategory == "compass") {
      _compassProvider.changeService(serviceData);
    }
  }


  Stream<WindModel> getWindStream() => _windProvider.wind.stream;
  Stream<PositionModel> getPositionStream() => _positionProvider.position.stream;
  Stream<CompassModel> getCompassStream() => _compassProvider.compass.stream;
  Stream<ServiceData> getActiveServices() => _activeServices.stream;
  Stream<ServiceList> getAvailableServices() => _availableServices.stream;
  Stream<List<ServiceList>> getProviderTypes() => _providerTypes.stream;
  Stream getProviderData() => _providerData.stream;
  Stream<ListAngleModel> getListAngleStream() => _listAngleProvider.listAngle.stream;
}
