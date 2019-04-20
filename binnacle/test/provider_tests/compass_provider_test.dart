import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sos/models/service_data.dart';
import 'package:sos/providers/compass_provider.dart';
import 'package:sos/services/compass_service.dart';
import 'package:sos/services/service_list.dart';
import 'package:sos/services/test_compass_service.dart';


void main() {
  CompassProvider _provider;
  PublishSubject _activeServiceWrapper = PublishSubject();
  var mockWrapper1 = MockCompassServiceWrapper(true);
  var mockWrapper2 = MockCompassServiceWrapper(false);

  setUp(() async {

    ServiceList _serviceList = ServiceList('compass', [mockWrapper1, mockWrapper2]);
    _provider = await CompassProvider(_serviceList);
    _provider.activeService.stream.listen((data) => _activeServiceWrapper.add(data));
    
  });

  test('Compass provider initialized', () {
    expect(_provider.runtimeType, CompassProvider);
  });

  test('setUpService sets a service', ()  {
    var old =  _activeServiceWrapper.last;
    _provider.setUpService(MockCompassServiceWrapper(false));
    var newValue = _activeServiceWrapper.last;

     expect(identical(old, newValue) , false);
  });

  test('changeService actually changes services', () async {
    var old;
    var newValue;

    
    await expectLater(identical(old, newValue), false);

    old = await  _activeServiceWrapper.last;
    print("old "+old.toString());


    await _provider.changeService(mockWrapper2.serviceData);
    newValue = await _activeServiceWrapper.last;

    print("new:  "+newValue.toString());


    

  });


}