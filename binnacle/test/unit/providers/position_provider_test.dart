import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sos/models/position_model.dart';
import 'package:sos/providers/position_provider.dart';
import 'package:sos/services/geolocation_service.dart';
import 'package:sos/services/service_list.dart';
import 'package:sos/enums.dart';



void main() {
  PositionProvider _provider;
  PublishSubject _activeServiceWrapper = PublishSubject();
  StreamController<PositionModel> _positionStreamWrapper = StreamController();

  

  setUp(() async {

    ServiceList _serviceList = ServiceList(ProviderType.position, [GeolocationServiceWrapper(), ]);
    _provider = await PositionProvider(_serviceList);
    _provider.activeService.stream.listen((data) { 
      _activeServiceWrapper.add(data);
   
    });

    _provider.position.stream.listen((data) { 
      _positionStreamWrapper.add(data);
   
    });
    
  });


  test('Position provider initialized', () async{
    expect(_provider.runtimeType, PositionProvider);
    await expectLater( await _activeServiceWrapper.isEmpty, false);

  });


   
}

class PositionServiceWrapper {
}
