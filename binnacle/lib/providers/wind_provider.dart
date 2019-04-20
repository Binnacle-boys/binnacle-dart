
// class WindProvider {

//     IWindService _service;
//     StreamController<WindModel> _stream = StreamController();
    
//     WindProvider({IWindService service}){
//       this._service = service;
//       this._stream.addStream(this._service.windStream.stream);

//     }
//     changeService(IWindService service)  async {

//     await this._service.windStream.close();
    
//     this._service = service;
//     await this._stream.addStream(this._service.windStream.stream);

//   }
//     StreamController<WindModel> get wind => _stream;


// }
// abstract class IWindService {
//   StreamController <WindModel> get windStream;

// }


import 'dart:async';
import 'package:sos/services/service_list.dart';

import '../models/wind_model.dart';
import '../models/wind_service_interface.dart';
import '../models/service_data.dart';
import '../models/provider_data.dart';
import '../services/service_wrapper_interface.dart';

import '../repository.dart';


class WindProvider {
  IWindService _currentService;

  ServiceList _serviceList; 
  StreamController<WindModel> _stream = StreamController();
  StreamController<ServiceData> _activeService = StreamController();
  StreamSubscription _subscription;
  StreamController<ServiceList> _availableServices = StreamController();

  ProviderData _providerData = ProviderData('wind', 'manual');
  StreamController _providerDataStream = StreamController();
  

  WindProvider(ServiceList serviceList){
    this._serviceList = serviceList;
    _availableServices.sink.add(_serviceList);
    _providerDataStream.sink.add(this._providerData);

  
    setUpService(this._serviceList.defaultService);
  }

  setUpService(ServiceWrapper serviceWrapper) {
    
    this._currentService = serviceWrapper.service; 
    this._activeService.sink.add(serviceWrapper.serviceData); 

    this._subscription = this._currentService.windStream.stream.listen((data) => this._stream.add(data));
    _subscription.onError((error)  {
      if(_providerData.mode == 'auto') {
        changeService( _serviceList.nextPriority( serviceWrapper.serviceData ).serviceData);
      }
    });
  }

  changeService(ServiceData serviceData)  async {
    await this._currentService.dispose();
    ServiceWrapper serviceWrapper = this._serviceList.service(serviceData);
    setUpService(serviceWrapper);

  }
  toggleMode(ProviderData providerData) {
    ProviderData temp;
    if ( providerData.mode == "manual" ) {
      temp = ProviderData(_providerData.type, 'auto');
    }
    if( providerData.mode == "auto" ) {
      temp = ProviderData(_providerData.type, 'manual');
    }
    this._providerData = temp;
    this._providerDataStream.sink.add(this._providerData);

  }

  StreamController<WindModel> get wind => this._stream;
  StreamController<ServiceData> get activeService => this._activeService;
  StreamController<ServiceList> get availableServices => _availableServices;
  StreamController get providerData => _providerDataStream;

} 

