import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sos/models/list_angle_model.dart';
import 'package:sos/providers/list_angle_provider.dart';
import 'package:sos/services/list_angle_service.dart';
import 'package:sos/services/service_list.dart';
import 'package:sos/enums.dart';



void main() {
  ListAngleProvider _provider;
  PublishSubject _activeServiceWrapper = PublishSubject();
  StreamController<ListAngleModel> _listAngleStreamWrapper = StreamController();

  

  setUp(() async {

    ServiceList _serviceList = ServiceList(ProviderType.list_angle, [ListAngleServiceWrapper(), ]);
    _provider = await ListAngleProvider(_serviceList);
    _provider.activeService.stream.listen((data) { 
      _activeServiceWrapper.add(data);
   
    });

    _provider.listAngle.stream.listen((data) { 
      _listAngleStreamWrapper.add(data);
   
    });
    
  });


  test('List angle provider initialized', () async{
    expect(_provider.runtimeType, ListAngleProvider);
    // await expectLater( await _activeServiceWrapper.isEmpty, false);

  });


   
}
