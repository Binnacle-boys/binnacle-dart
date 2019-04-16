import 'dart:async';
import 'package:rxdart/rxdart.dart';

import './providers/position_provider.dart';
import './providers/wind_provider.dart';
import './providers/compass_provider.dart';

import './services/geolocation_service.dart';
import './services/weather_service.dart';
import './services/compass_service.dart';
import './services/test_compass_service.dart';

import 'models/position_model.dart';
import 'models/compass_model.dart';
import 'models/wind_model.dart';
import 'models/service_data.dart';

class ServiceList {

  final String type;
  List<dynamic> _list = [CompassServiceWrapper(), MockCompassServiceWrapper()];
  

  ServiceList(this.type);

  List<dynamic> get serviceList => _list;
  
  dynamic service(ServiceData data) => _list.firstWhere((wrapper) => 
    identical(wrapper.serviceData, data)).service;

  dynamic get defaultService => _list.firstWhere((wrapper) => wrapper.isDefault == true);

}
abstract class ServiceWrapper {
  //! This isn't working???
  ServiceWrapper(); 
}
class CompassServiceWrapper extends ServiceWrapper{
  final ServiceData _serviceData = ServiceData('compass', 'flutter compass');
  final bool _default = true;

  CompassServiceWrapper();

  get service => CompassService();
  get serviceData => this._serviceData;
  bool get isDefault => this._default;

}
class MockCompassServiceWrapper extends ServiceWrapper{
  final ServiceData _serviceData = ServiceData('compass', 'mock compass');
  final bool _default = false;

  MockCompassServiceWrapper();

  get service => TestCompassService();
  ServiceData get serviceData => this._serviceData;
  bool get isDefault => this._default;
}




class Repository {

  PositionProvider _positionProvider;
  WindProvider _windProvider;
  CompassProvider _compassProvider;
  StreamController<ServiceData> _activeServices = StreamController();
  StreamController<dynamic> _availableServices = StreamController();
  final List<ProviderData> _providers = [];
  ServiceList compassServiceList;


  Repository(BehaviorSubject<PositionModel> positionStream) {
    
    // compassServiceList = ServiceList('compass', {
    //   ServiceData('compass', 'geolocation') : () => new CompassService(),
    //   ServiceData('compass', 'mock') : () => new TestCompassService()
    // });
    compassServiceList = ServiceList('compass');

    this._positionProvider = PositionProvider( service: new GeolocationService() );
    this._windProvider = WindProvider( service: new WeatherService(positionStream) );
    var temp = compassServiceList.defaultService;
    _activeServices.sink.add(temp.serviceData);
    this._compassProvider = CompassProvider( service: temp.service );
    
    this._providers.add(this._compassProvider.providerData);


    _availableServices.sink.add(compassServiceList);
  }

  //? I think passing in ServiceData here would be better
  // swapCompassStream(String serviceName) {
  //   if(!compassServiceList.serviceFactory.containsKey(serviceName)) {
  //     this._activeServices.sink.addError("Attemping to start a service that does not exist");
  //     return;
  //   }
  //   var service = this.compassServiceList.serviceFactory[serviceName]();
  //   this._compassProvider.changeService(service);
  //   this._activeServices.sink.add(service.serviceData);
  // }
  setActiveService(ServiceData serviceData) {
    var wrapper = compassServiceList.service(serviceData);
    print("!!!" +wrapper.toString());
    // _compassProvider.changeService( wrapper.service);
    _activeServices.sink.add(serviceData);

  }


  Stream<WindModel> getWindStream() => _windProvider.wind.stream;
  Stream<PositionModel> getPositionStream() => _positionProvider.position.stream;
  Stream<CompassModel> getCompassStream() => _compassProvider.compass.stream;
  Stream<ServiceData> getActiveServices() => _activeServices.stream;
  Stream<dynamic> getAvailableServices() => _availableServices.stream;
  
}