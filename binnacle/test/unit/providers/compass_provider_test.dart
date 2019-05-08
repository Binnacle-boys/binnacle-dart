import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sos/models/compass_model.dart';
import 'package:sos/providers/compass_provider.dart';
import 'package:sos/services/compass_service.dart';
import 'package:sos/services/service_list.dart';
import 'package:sos/services/test_compass_service.dart';
import 'package:sos/enums.dart';


void main() {
  CompassProvider _provider;
  PublishSubject _activeServiceWrapper = PublishSubject();
  StreamController<CompassModel> _compassStreamWrapper = StreamController();

  setUp(() async {

    ServiceList _serviceList = ServiceList(ProviderType.compass, [CompassServiceWrapper(), MockCompassServiceWrapper(false)]);
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


   
}
