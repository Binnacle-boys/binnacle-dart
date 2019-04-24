import 'package:flutter_test/flutter_test.dart';
import 'package:sos/services/compass_service.dart';

void main() {
  CompassService _service;

  setUp(() {
    _service = CompassService();
  });

  test('compass service is instantiated', () {
    expect(_service.runtimeType, CompassService);
  });

  test('dispose does not emit new states', () {
    expectLater(_service.compassStream.stream, emitsInOrder([]));
    _service.dispose();
  });
}