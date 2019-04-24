import 'dart:async';
import 'package:sos/services/service_list.dart';

import '../models/position_model.dart';
import '../models/position_service_interface.dart';
import '../models/service_data.dart';
import '../models/provider_data.dart';
import '../services/service_wrapper_interface.dart';

class PositionProvider {
  IPositionService _currentService;

  ServiceList _serviceList;
  StreamController<PositionModel> _stream = StreamController();
  StreamController<ServiceData> _activeService = StreamController();
  StreamSubscription _subscription;
  StreamController<ServiceList> _availableServices = StreamController();

  ProviderData _providerData = ProviderData('position', 'manual');
  StreamController<ProviderData> _providerDataStream = StreamController();

  PositionProvider(ServiceList serviceList) {
    this._serviceList = serviceList;
    _availableServices.sink.add(_serviceList);
    _providerDataStream.sink.add(this._providerData);

    setUpService(this._serviceList.defaultService);
  }

  setUpService(ServiceWrapper serviceWrapper) {
    this._currentService = serviceWrapper.service;
    this._activeService.sink.add(serviceWrapper.serviceData);

    this._subscription = this
        ._currentService
        .positionStream
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

  StreamController<PositionModel> get position => this._stream;
  StreamController<ServiceData> get activeService => this._activeService;
  StreamController<ServiceList> get availableServices => _availableServices;
  StreamController<ProviderData> get providerData => _providerDataStream;
}
