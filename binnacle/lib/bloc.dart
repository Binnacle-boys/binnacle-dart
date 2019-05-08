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
  Repository _repository;

//TODO type these controllers
  final _positionController = BehaviorSubject<PositionModel>();
  final _availableServices = BehaviorSubject<List<ServiceList>>();
  final _activeServices = BehaviorSubject<List<ServiceData>>();
  final _providerData = BehaviorSubject<List<ProviderData>>();
  final _windContoller = BehaviorSubject<WindModel>();
  final _compassController = BehaviorSubject<CompassModel>();
  final _listAngleController = BehaviorSubject<ListAngleModel>();

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

    this._btIsScanning.addStream(_repository.isScanning().stream);
    this._btScanResults.addStream(_repository.scanResults().stream);


  }

  BehaviorSubject<List<ServiceList>> get availableServices => _availableServices.stream;
  BehaviorSubject<List<ServiceData>> get activeServices => _activeServices.stream;
  BehaviorSubject<List<ProviderData>> get providerData => _providerData.stream;
  BehaviorSubject<WindModel> get wind => _windContoller.stream;
  BehaviorSubject<CompassModel> get compass => _compassController.stream;
  BehaviorSubject<PositionModel> get position => _positionController.stream;
  BehaviorSubject<ListAngleModel> get listAngle => _listAngleController.stream;




  BehaviorSubject<bool> get isScanning => _btIsScanning; //bt
  BehaviorSubject get scanResults => _btScanResults; //bt
  Function get startScan => _repository.bluetooth.startScan; //bt
  Function get connect => _repository.bluetooth.connect;


  // change data
  //* These don't actually do anything yet. Just leaving them
  //* as a reference for when BLoC needs these functions
  Function(PositionModel) get changePosition => _positionController.sink.add;

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
}
