import 'dart:async';
import '../models/compass_model.dart';
import '../models/compass_service_interface.dart';
import '../models/service_data.dart';
import '../models/provider_data.dart';

import '../repository.dart';



class CompassProvider {
  ICompassService _currentService;

  ServiceList _serviceList; 
  StreamController<CompassModel> _stream = StreamController();
  StreamController<ServiceData> _activeService = StreamController();
  StreamSubscription _subscription;
  StreamController<ServiceList> _availableServices = StreamController();


  ProviderData _providerData = ProviderData('compass', 'manual');
  StreamController _providerDataStream = StreamController();
  

  CompassProvider(ServiceList serviceList){
    this._serviceList = serviceList;
    _availableServices.sink.add(_serviceList);
    _providerDataStream.sink.add(this._providerData);

  
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
  toggleMode(ProviderData providerData) {
    ProviderData temp;
    if( providerData.mode == "manual") {
      temp = ProviderData(_providerData.type, 'auto');
    }
    if( providerData.mode == "auto") {
      temp = ProviderData(_providerData.type, 'manual');
    }
    this._providerData = temp;
    this._providerDataStream.sink.add(this._providerData);

  }

  StreamController<CompassModel> get compass => this._stream;
  StreamController<ServiceData> get activeService => this._activeService;
  StreamController<ServiceList> get availableServices => _availableServices;
  StreamController get providerData => _providerDataStream;

}
