import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sos/models/compass_model.dart';
import 'package:sos/models/list_angle_model.dart';
import 'package:sos/services/service_list.dart';
import 'package:sos/voice_alerts.dart';
import './repository.dart';
import 'models/position_model.dart';
import 'package:sos/models/ideal_heading_model.dart';
import 'models/wind_model.dart';
import 'models/service_data.dart';
import 'models/provider_data.dart';

class Bloc extends Object {
  Repository _repository;

  final _idealBoom = BehaviorSubject<double>();
  final _btIsScanning = BehaviorSubject<bool>(); //bt
  final _btScanResults = BehaviorSubject();

  BehaviorSubject<List<ServiceList>> get availableServices => _availableServices.stream;
  BehaviorSubject<List<ServiceData>> get activeServices => _activeServices.stream;
  BehaviorSubject<List<ProviderData>> get providerData => _providerData.stream;
  BehaviorSubject<WindModel> get wind => _windContoller.stream;
  BehaviorSubject<CompassModel> get compass => _compassController.stream;
  BehaviorSubject<PositionModel> get position => _positionController.stream;
  BehaviorSubject<ListAngleModel> get listAngle => _listAngleController.stream;
  BehaviorSubject<double> get idealBoom => _idealBoom.stream;

  //Bluetooth functions
  BehaviorSubject<bool> get isScanning => _btIsScanning; 
  BehaviorSubject get scanResults => _btScanResults; 
  Function get startScan => _repository.bluetooth.startScan; 
  Function get connect => _repository.bluetooth.connect;

  // Navigation functions
  Future startNavigation(start, end) => _repository.navigator.start(start, end);
  BehaviorSubject get navigationEventBus => _repository.navigator.eventBus;
  BehaviorSubject<IdealHeadingModel> get idealHeading => _repository.navigator.idealHeading;
  List<LatLng> getCourse() => _repository.navigator.getCourse();
  ReplaySubject<PositionModel> get courseHistory => _repository.navigator.positionHistory;
  double get navigationCloseEnough => _repository.navigator.closeEnough;
  double get navigationMaxOffset => _repository.navigator.maxOffset;
  Function setNavigationCloseEnough(double value) => _repository.navigator.setCloseEnough;
  Function setNavigationMaxOffset(double value) => _repository.navigator.setMaxOffset;


  // Map State Variables
  Map<PolylineId, Polyline> lines = new Map();
  List<Marker> markers = new List();
  List<LatLng> sailedCourse = new List();

  final BehaviorSubject<PositionModel> _positionController = BehaviorSubject<PositionModel>();
  final BehaviorSubject<List<ServiceList>> _availableServices = BehaviorSubject<List<ServiceList>>();
  final BehaviorSubject<List<ServiceData>> _activeServices = BehaviorSubject<List<ServiceData>>();
  final BehaviorSubject<List<ProviderData>> _providerData = BehaviorSubject<List<ProviderData>>();

  final BehaviorSubject<WindModel> _windContoller = BehaviorSubject<WindModel>();
  final BehaviorSubject<CompassModel> _compassController = BehaviorSubject<CompassModel>();
  final BehaviorSubject<ListAngleModel> _listAngleController = BehaviorSubject<ListAngleModel>();

  VoiceAlerts _voiceAlerts;
  Function voiceAlertTest() => _voiceAlerts.test;

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
    this._idealBoom.addStream(calcIdealBoomStream(_compassController.stream, _windContoller.stream));

    this._btIsScanning.addStream(_repository.isScanning().stream);
    this._btScanResults.addStream(_repository.scanResults().stream);

    _voiceAlerts = new VoiceAlerts(navigationEventBus);
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
