import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sos/models/compass_model.dart';
import 'package:sos/models/service_data.dart';
import 'package:sos/providers/compass_provider.dart';
import 'package:sos/services/compass_service.dart';
import 'package:sos/services/service_list.dart';
import 'package:sos/services/test_compass_service.dart';


void main() {
  CompassProvider _provider;
  PublishSubject _activeServiceWrapper = PublishSubject();
  PublishSubject<CompassModel> _compassStreamWrapper = PublishSubject();
  var mockWrapper1 = MockCompassServiceWrapper(true);
  var mockWrapper2 = MockCompassServiceWrapper(false);

  setUp(() async {

    ServiceList _serviceList = ServiceList('compass', [mockWrapper1, mockWrapper2]);
    _provider = await CompassProvider(_serviceList);
    _provider.activeService.stream.listen((data) { 
      _activeServiceWrapper.add(data);
      print("ServiceData ---- "+data.toString());
   
    });

    _provider.compass.stream.listen((data) { 
      _compassStreamWrapper.add(data);
      print("Direction ---- "+data.direction.toString());
   
    });
    
  });


  test('Compass provider initialized', () async{
    expect(_provider.runtimeType, CompassProvider);
    await expectLater( await _activeServiceWrapper.isEmpty, false);

  });


  test('changeServices changes the service', () async  {
    // var old =  _compassStreamWrapper.stream.first;

    expect(
      _activeServiceWrapper.stream,
       emitsInAnyOrder( <CompassModel>[
        new CompassModel(direction: 0.0),
        new CompassModel(direction: 1.0),
        // new CompassModel(direction: 2.0),
      ])
    );
    
    
  });
}

//   test('changeService actually changes services', () async {
//     var old;
//     var newValue;

//     await expectLater(identical(old, newValue), false);
//     old = await  _activeServiceWrapper.last;
//     print("old "+old.toString());


//     await _provider.changeService(mockWrapper2.serviceData);
//     newValue = await _activeServiceWrapper.last;

//     print("new:  "+newValue.toString());
//   });



