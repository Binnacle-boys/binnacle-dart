import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/compass_service.dart';

void main() {
  CompassService _service;

  setUp( (){
    _service = CompassService();
  });
  
  test('compass service is instantiated', () {
    expect(_service.runtimeType, CompassService);
  });

  test('dispose does not emit new states', () {
    expectLater(_service.compassStream, emitsInOrder([]));
    _service.dispose();
  });
}
