import 'package:flutter_test/flutter_test.dart';

import 'package:sos/providers/sensor_provider.dart';
import 'package:sos/services/sensor_service.dart';

void main() {
  group('SensorProvider', () {
    test('construction', () {
      SensorProvider testModule = new SensorProvider();

      expect(testModule.workingChildren.length, 0);
      expect(testModule.inactiveChildren.length, 0);

      expect(testModule.stream, null);

      expect(testModule.manual, false);

      expect(testModule.active, null);
    });

    test('add SensorService', () async {
      SensorProvider testModule = new SensorProvider();
      var dumStream =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 100).take(5);
      SensorService testService =
          new SensorService("Test Service", 5, dumStream);
      testService.workingStream.add(true);

      await Future.delayed(const Duration(microseconds: 100), () {});

      testModule.add(testService);

      expect(testService.working, true);

      expect(testModule.workingChildren.length, 1);
      expect(testModule.inactiveChildren.length, 0);
      expect(testModule.stream is Stream<int>, true);
      expect(testModule.manual, false);
      expect(testModule.active != null, true);
      expect(testModule.active.stream, testModule.stream);

      expect(testModule.stream, emits(100));
    });

    test('prioritization', () async {
      SensorProvider testModule = new SensorProvider();
      var dumStreamA =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 100).take(5);
      SensorService testServiceA =
          new SensorService("Test Service A", 5, dumStreamA);
      testModule.add(testServiceA);
      testServiceA.workingStream.add(true);

      var dumStreamB =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 250).take(5);
      SensorService testServiceB =
          new SensorService("Test Service B", 1, dumStreamB);
      testModule.add(testServiceB);
      testServiceB.workingStream.add(true);

      var dumStreamC =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 500).take(5);
      SensorService testServiceC =
          new SensorService("Test Service C", 3, dumStreamC);
      testModule.add(testServiceC);
      testServiceC.workingStream.add(true);

      await Future.delayed(const Duration(microseconds: 100), () {});

      expect(testModule.workingChildren.length, 3);
      expect(testModule.inactiveChildren.length, 0);

      expect(testModule.workingChildren.indexOf(testServiceA), 2);
      expect(testModule.workingChildren.indexOf(testServiceB), 0);
      expect(testModule.workingChildren.indexOf(testServiceC), 1);
    });

    test('prioritization with no longer active', () async {
      SensorProvider testModule = new SensorProvider();
      var dumStreamA =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 100).take(5);
      SensorService testServiceA =
          new SensorService("Test Service A", 5, dumStreamA);
      testModule.add(testServiceA);
      testServiceA.workingStream.add(true);

      var dumStreamB =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 300).take(5);
      SensorService testServiceB =
          new SensorService("Test Service B", 1, dumStreamB);
      testModule.add(testServiceB);
      testServiceB.workingStream.add(true);

      var dumStreamC =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 500).take(5);
      SensorService testServiceC =
          new SensorService("Test Service C", 3, dumStreamC);
      testModule.add(testServiceC);
      testServiceC.workingStream.add(true);

      await Future.delayed(const Duration(microseconds: 100), () {});

      expect(testModule.workingChildren.length, 3);

      expect(testModule.workingChildren.indexOf(testServiceB), 0);

      testServiceB.workingStream.add(false);

      await Future.delayed(const Duration(microseconds: 100), () {});

      expect(testModule.workingChildren.length, 2);
      expect(testModule.active, testServiceC);
      expect(testModule.stream, emits(500));
    });

    test('manually set service', () async {
      SensorProvider testModule = new SensorProvider();
      var dumStreamA =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 100).take(5);
      SensorService testServiceA =
          new SensorService("Test Service A", 5, dumStreamA);
      testModule.add(testServiceA);
      testServiceA.workingStream.add(true);

      var dumStreamB =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 300).take(5);
      SensorService testServiceB =
          new SensorService("Test Service B", 1, dumStreamB);
      testModule.add(testServiceB);
      testServiceB.workingStream.add(true);

      var dumStreamC =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 500).take(5);
      SensorService testServiceC =
          new SensorService("Test Service C", 3, dumStreamC);
      testModule.add(testServiceC);
      testServiceC.workingStream.add(true);

      await Future.delayed(const Duration(microseconds: 100), () {});

      testModule.set(testServiceA);

      expect(testModule.manual, true);

      expect(testModule.stream, emits(100));

      testModule.reset();
      expect(testModule.manual, false);
      expect(testModule.stream, emits(300));
    });

    test('stream changes when its service stops working', () async {
      SensorProvider testModule = new SensorProvider();
      var dumStreamA =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 100)
              .take(15);
      SensorService testServiceA =
          new SensorService("Test Service A", 5, dumStreamA);
      testModule.add(testServiceA);
      testServiceA.workingStream.add(true);

      var dumStreamB =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 300)
              .take(15);
      SensorService testServiceB =
          new SensorService("Test Service B", 1, dumStreamB);
      testModule.add(testServiceB);
      testServiceB.workingStream.add(true);

      await Future.delayed(const Duration(microseconds: 100), () {});

      testServiceB.workingStream.add(false);

      await Future.delayed(const Duration(microseconds: 100), () {});

      expect(testModule.manual, false);
      expect(testModule.stream, emits(100));
    });
  });
}
