import 'dart:math';

import 'package:rxdart/rxdart.dart';
import 'package:sos/models/compass_model.dart';
import 'package:sos/models/list_angle_model.dart';
import 'package:sos/services/service_list.dart';
import './repository.dart';
import 'models/position_model.dart';
import 'models/wind_model.dart';
import 'models/service_data.dart';
import 'models/provider_data.dart';

class Bloc extends Object {
<<<<<<< HEAD
  Repository _repository;

//TODO type these controllers
  final _positionController = BehaviorSubject<PositionModel>();
  final _availableServices = BehaviorSubject<List<ServiceList>>();
  final _activeServices = BehaviorSubject<List<ServiceData>>();
  final _providerData = BehaviorSubject<List<ProviderData>>();
  final _windContoller = BehaviorSubject<WindModel>();
  final _compassController = BehaviorSubject<CompassModel>();
  final _listAngleController = BehaviorSubject<ListAngleModel>();
  final _idealBoom = BehaviorSubject<double>();

  final _btIsScanning = BehaviorSubject<bool>(); //bt
  final _btScanResults = BehaviorSubject();

  Bloc() {
    this._repository = Repository(_positionController);
    this._positionController.addStream(_repository.getPositionStream());
    this._windContoller.addStream(_repository.getWindStream());
    this._compassController.addStream(_repository.getCompassStream());
    this._availableServices.addStream(_repository.getAvailableServices());
    this._activeServices.addStream(_repository.getActiveServices());
    this._providerData.addStream(_repository.getProviderData());
    this._listAngleController.addStream(_repository.getListAngleStream());
    this._idealBoom.addStream(calcIdealBoomStream(_compassController.stream, _windContoller.stream));
    this._btIsScanning.addStream(_repository.isScanning().stream);
    this._btScanResults.addStream(_repository.scanResults().stream);
  }

=======
>>>>>>> pr_us3
  BehaviorSubject<List<ServiceList>> get availableServices => _availableServices.stream;
  BehaviorSubject<List<ServiceData>> get activeServices => _activeServices.stream;
  BehaviorSubject<List<ProviderData>> get providerData => _providerData.stream;
  BehaviorSubject<WindModel> get wind => _windContoller.stream;
  BehaviorSubject<CompassModel> get compass => _compassController.stream;
  BehaviorSubject<PositionModel> get position => _positionController.stream;
  BehaviorSubject<ListAngleModel> get listAngle => _listAngleController.stream;

  BehaviorSubject<double> get idealBoom => _idealBoom.stream;

  BehaviorSubject<bool> get isScanning => _btIsScanning; //bt
  BehaviorSubject get scanResults => _btScanResults; //bt
  Function get startScan => _repository.bluetooth.startScan; //bt
  Function get connect => _repository.bluetooth.connect;

  // change data
  //* These don't actually do anything yet. Just leaving them
  //* as a reference for when BLoC needs these functions
  Function(PositionModel) get changePosition => _positionController.sink.add;

  Repository _repository;

  final BehaviorSubject<PositionModel> _positionController = BehaviorSubject<PositionModel>();
  final BehaviorSubject<List<ServiceList>> _availableServices = BehaviorSubject<List<ServiceList>>();
  final BehaviorSubject<List<ServiceData>> _activeServices = BehaviorSubject<List<ServiceData>>();
  final BehaviorSubject<List<ProviderData>> _providerData = BehaviorSubject<List<ProviderData>>();

  final BehaviorSubject<WindModel> _windContoller = BehaviorSubject<WindModel>();
  final BehaviorSubject<CompassModel> _compassController = BehaviorSubject<CompassModel>();
  final BehaviorSubject<ListAngleModel> _listAngleController = BehaviorSubject<ListAngleModel>();

  Bloc() {
    this._repository = Repository(_positionController);

    this._availableServices.addStream(_repository.availableServices);
    this._activeServices.addStream(_repository.activeServices);
    this._providerData.addStream(_repository.providerData);

    /// Data points
    this._positionController.addStream(_repository.position);
    this._windContoller.addStream(_repository.wind);
    this._compassController.addStream(_repository.compass);
    this._listAngleController.addStream(_repository.listAngle);
  }

  setActiveService(ServiceData serviceData) {
    this._repository.setActiveService(serviceData);
  }

  toggleMode(ProviderData providerData) {
    _repository.toggleMode(providerData);
  }

  void dispose() async {
    await _positionController?.drain();
    await _positionController?.close();
    await _windContoller?.drain();
    await _windContoller?.close();
    await _listAngleController?.drain();
    await _listAngleController?.close();
  }

  Stream<double> calcIdealBoomStream(Stream<CompassModel> compass, Stream<WindModel> wind) {
    return CombineLatestStream.combine2(compass, wind, (c, w) => calcBoomAngle(c, w));
  }

  double calcBoomAngle(compass, wind) {
    double _comp = compass.direction;
    double _wind = wind.deg;
    double a = 0.0;
    double b = 180.0;
    double c = 0.0;
    double d = 90.0;
    double interval = (d - c) / (b - a);
    double delta = (_wind - _comp) % 360;
    if (delta > 180) {
      delta = delta - 360;
    }
    double ret = (c + delta * interval);

    return ret * pi / 180 + pi;
  }
}
