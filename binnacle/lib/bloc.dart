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
  BehaviorSubject<List<ServiceList>> get availableServices => _availableServices.stream;
  BehaviorSubject<List<ServiceData>> get activeServices => _activeServices.stream;
  BehaviorSubject<List<ProviderData>> get providerData => _providerData.stream;
  BehaviorSubject<WindModel> get wind => _windContoller.stream;
  BehaviorSubject<CompassModel> get compass => _compassController.stream;
  BehaviorSubject<PositionModel> get position => _positionController.stream;
  BehaviorSubject<ListAngleModel> get listAngle => _listAngleController.stream;
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
}
