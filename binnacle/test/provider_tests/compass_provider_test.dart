import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sos/services/test_compass_service.dart';
import 'package:sos/providers/compass_provider.dart';

class MockCompassService extends Mock implements TestCompassService {}

void main() {
  CompassProvider _provider;
  TestCompassService _service;

  setUp(() {
    _service = TestCompassService();
    _provider = CompassProvider(service: _service);
  });

  test('compass provider is initialized', () {
    expect(_provider.runtimeType, CompassProvider);
  });
}
