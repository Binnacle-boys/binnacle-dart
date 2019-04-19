import 'package:rxdart/rxdart.dart';
import 'package:sos/models/compass_model.dart';
import 'package:sos/models/list_angle_model.dart';
import './repository.dart';
import 'models/position_model.dart';
import 'models/wind_model.dart';
import 'models/service_data.dart';
import 'models/provider_data.dart';

class Bloc extends Object {
  Repository _repository;

//TODO type these controllers
  final _headingController = BehaviorSubject<String>();
  final _positionController = BehaviorSubject<PositionModel>();
  final _availableServices = BehaviorSubject();
  final _activeServices = BehaviorSubject();
  final _providerData = BehaviorSubject();
  

  final _windContoller = BehaviorSubject<WindModel>();
  final _compassController = BehaviorSubject<CompassModel>();
  final _listAngleController = BehaviorSubject<ListAngleModel>();
  //? Should this contructor be refactored in to an aync factory?
  Bloc() {
    // * This line is just a dummy position -- delete it when Position works
    //this._positionController.add(PositionModel(lat: 89.4, lon: 121.12));

    this._repository = Repository(_positionController);
    this._positionController.addStream(_repository.getPositionStream());
    this._windContoller.addStream(_repository.getWindStream());
    this._compassController.addStream(_repository.getCompassStream());
    this._availableServices.addStream(_repository.getAvailableServices());
    this._activeServices.addStream(_repository.getActiveServices());

    this._providerData.addStream(_repository.getProviderData());
    this._listAngleController.addStream(_repository.getListAngleStream());

  }


  BehaviorSubject get availableServices => _availableServices.stream;
  BehaviorSubject get activeServices => _activeServices.stream;
  BehaviorSubject get providerData => _providerData.stream;
  BehaviorSubject<WindModel> get wind => _windContoller.stream;
  BehaviorSubject<CompassModel> get compass => _compassController.stream;
  BehaviorSubject<PositionModel> get position =>_positionController.stream;
  BehaviorSubject<ListAngleModel> get listAngle => _listAngleController.stream;
  // change data
  //* These don't actually do anything yet. I'm just leaving them
  //* as a reference for whene I need to have functions in BLoC
  Function(String) get changeHeading => _headingController.sink.add;
  Function(PositionModel) get changePosition => _positionController.sink.add;

  setActiveService(ServiceData serviceData) {
    this._repository.setActiveService(serviceData);
  }
  toggleMode(ProviderData providerData) {
    _repository.toggleMode(providerData);
  }

  void dispose() async {
    await _headingController?.drain();
    await _headingController?.close();
    await _positionController?.drain();
    await _positionController?.close();
    await _windContoller?.drain();
    await _windContoller?.close();
    await _listAngleController?.drain();
    await _listAngleController?.close();
  }
}
