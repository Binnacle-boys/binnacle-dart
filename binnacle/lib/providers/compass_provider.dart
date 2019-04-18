import 'dart:async';
import '../models/compass_model.dart';
import '../models/compass_service_interface.dart';
import '../models/service_data.dart';

import '../repository.dart';

class ProviderData {
  final String _provides;
  String _mode;

  ProviderData(this._provides, this._mode);

  set mode(String newMode) => this._mode = newMode;
  String get mode => this._mode;
  String get provides => this._provides;
  
}


class CompassProvider {
  ICompassService _currentService;

  ServiceList _serviceList; 
  StreamController<CompassModel> _stream = StreamController();
  StreamController<ServiceData> _activeService = StreamController();
  ProviderData providerData = ProviderData('compass', 'manual');
  StreamSubscription _subscription;
  StreamController<ServiceList> _availableServices = StreamController();

  CompassProvider(ServiceList serviceList){
    this._serviceList = serviceList;
    _availableServices.sink.add(_serviceList);
  
    setUpService(this._serviceList.defaultService);
  }
  setUpService(ServiceWrapper serviceWrapper) {
    
    this._currentService = serviceWrapper.service; 
    this._activeService.sink.add(serviceWrapper.serviceData); 

    this._subscription = this._currentService.compassStream.stream.listen((data) => this._stream.add(data));
    _subscription.onError((error) => {
      //* I want to get the next the service and call change servce again
      print(error.toString())

    });
  }

  changeService(ServiceData serviceData)  async {
    await this._currentService.dispose();
    ServiceWrapper serviceWrapper = this._serviceList.service(serviceData);
    setUpService(serviceWrapper);


    // await this._stream.addStream(this._currentService.compassStream.stream);
  }

  StreamController<CompassModel> get compass => this._stream;
  StreamController<ServiceData> get activeService => this._activeService;
  StreamController<ServiceList> get availableServices => _availableServices;

}
