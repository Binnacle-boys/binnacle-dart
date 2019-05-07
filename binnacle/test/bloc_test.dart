import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sos/bloc.dart';
import 'package:sos/models/position_model.dart';
import 'package:sos/models/provider_data.dart';
import 'package:sos/models/service_data.dart';
import 'package:sos/models/wind_model.dart';
import 'package:sos/services/service_list.dart';

void main() {
  Bloc _bloc;
  setUp(() {
    _bloc = new Bloc();
  });
  group("Bloc", () {
    test('Bloc is instantiated', () {
      expect(_bloc.runtimeType, Bloc);
    });
    // BehaviorSubject<List<ServiceList>> get availableServices => _availableServices.stream;
    test('Bloc availableServises getter', () async {
      BehaviorSubject _availableServices = _bloc.availableServices;
      var firstInStream = await _availableServices.first;
      expect(firstInStream[0].runtimeType, ServiceList);

      // for (var availableService in firstInStream) {
      //   expect(availableService.runtimeType, ServiceList);
      // }
    });
    /*
    // BehaviorSubject<List<ServiceData>> get activeServices => _activeServices.stream;

    test('Bloc activeServises getter', () async {
      BehaviorSubject _activeServices = _bloc.activeServices;
      var firstInStream = await _activeServices.first;
      for (var activeService in firstInStream) {
        expect(activeService.runtimeType, ServiceData);
      }
    });
    // BehaviorSubject<List<ProviderData>> get providerData => _providerData.stream;
    test('Bloc providerData getter', () async {
      BehaviorSubject _providerData = _bloc.providerData;
      var firstInStream = await _providerData.first;
      for (var provider in firstInStream) {
        expect(provider.runtimeType, ProviderData);
      }
    });
    /*
    // BehaviorSubject<CompassModel> get compass => _compassController.stream;
    test('Bloc compass getter', () async {
      BehaviorSubject _compass = _bloc.compass;
      var firstInStream = await _compass.;
      expect(firstInStream.direction, 0.0);
    });
    */

    // BehaviorSubject<ListAngleModel> get listAngle => _listAngleController.stream;
    test('Bloc listAngle getter', () async {
      BehaviorSubject _listAngle = _bloc.listAngle;
      var firstInStream = await _listAngle.first;
      expect(firstInStream.angle, 0.0);
    });
    // BehaviorSubject<PositionModel> get position => _positionController.stream;
    // test('Bloc position getter', () async {
    //   BehaviorSubject _position = _bloc.position;
    //   _bloc.changePosition(new PositionModel(lat: 0.0, lon: 0.0, speed: 0.0));
    //   var firstInStream = await _position.first;
    //   expect(firstInStream.runtimeType, PositionModel);
    // });

    // BehaviorSubject<WindModel> get wind => _windContoller.stream;
    // test('Bloc wind getter', () async {
    //   BehaviorSubject _wind = _bloc.wind;
    //   var firstInStream = await _wind.first;
    //   print(firstInStream);
    //   expect(firstInStream.runtimeType, WindModel);
    // });

    //  setActiveService(ServiceData serviceData) {

    // TODO add a toggleMode test
    //  toggleMode(ProviderData providerData) {
    //   test('Bloc toggleMode', () async {
    //     expect(, WindModel);
    //   });

    // TODO comment back in when position/wind services are seeded
    //  void dispose() async
    //   test('Bloc dispose', () async {
    //     await _bloc.dispose();
    //     bool isClosed = _bloc.wind.isClosed;
    //     expect(isClosed, true);

    //     isClosed = _bloc.position.isClosed;
    //     expect(isClosed, true);

    //     isClosed = _bloc.listAngle.isClosed;
    //     expect(isClosed, true);
    //   });
    */
  });
}
