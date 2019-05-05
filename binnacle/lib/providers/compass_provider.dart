import 'dart:async';
import 'package:sos/services/service_list.dart';

import '../models/compass_model.dart';
import '../models/compass_service_interface.dart';
import '../models/service_data.dart';
import '../models/provider_data.dart';
import '../services/service_wrapper_interface.dart';
import '../enums.dart';
class CompassProvider {
  ICompassService _currentService;

  ServiceList _serviceList;
  StreamController<CompassModel> _stream = StreamController();
  StreamController<ServiceData> _activeService = StreamController();
  StreamSubscription _subscription;
  StreamController<ServiceList> _availableServices = StreamController();

  ProviderData _providerData = ProviderData(ProviderType.compass, 'manual');
  StreamController<ProviderData> _providerDataStream = StreamController();

  CompassProvider(ServiceList serviceList) {
    this._serviceList = serviceList;
    _availableServices.sink.add(_serviceList);
    _providerDataStream.sink.add(this._providerData);

    setUpService(this._serviceList.defaultService);
  }

  setUpService(ServiceWrapper serviceWrapper) {
    this._currentService = serviceWrapper.service;
    this._activeService.sink.add(serviceWrapper.serviceData);
    print('SETUP SERVICE -- NEW CURRENT SERVICE' +this._currentService.toString());
    print('SETUP SERVICE -- NEW SERVICEWRAPPER' +serviceWrapper.toString());


    this._subscription = this
        ._currentService
        .compassStream
        .stream
        .listen((data) => this._stream.add(data));
    _subscription.onError((error) {
      if (_providerData.mode == 'auto') {
        changeService(
            _serviceList.nextPriority(serviceWrapper.serviceData).serviceData);
      }
    });
  }

  changeService(ServiceData serviceData) async {
    await this._currentService.dispose();
    ServiceWrapper serviceWrapper = this._serviceList.service(serviceData);
    setUpService(serviceWrapper);
  }

  toggleMode(ProviderData providerData) {
    ProviderData temp;
    if (providerData.mode == "manual") {
      temp = ProviderData(_providerData.type, 'auto');
    }
    if (providerData.mode == "auto") {
      temp = ProviderData(_providerData.type, 'manual');
    }
    this._providerData = temp;
    this._providerDataStream.sink.add(this._providerData);
  }

  StreamController<CompassModel> get compass => this._stream;
  StreamController<ServiceData> get activeService => this._activeService;
  StreamController<ServiceList> get availableServices => _availableServices;
  StreamController<ProviderData> get providerData => _providerDataStream;
}
