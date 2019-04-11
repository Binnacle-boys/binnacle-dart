// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:sos/providers/sensor_provider.dart';
import 'package:sos/services/sensor_service.dart';

void main() {
  group('SensorProvider', () {
    test('construction', () {
      SensorProvider testModule = new SensorProvider();

      expect(testModule.children.length, 0);
      expect(testModule.getWorkingList().length, 0);

      expect(testModule.stream, null);

      expect(testModule.manual, false);

      expect(testModule.getActive(), null);
    });

    test('add SensorService', () {
      SensorProvider testModule = new SensorProvider();
      var dumStream =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 100).take(5);
      SensorService testService =
          new SensorService("Test Service", 5, dumStream);

      testModule.add(testService);

      expect(testModule.getWorkingList().length, 1);
      expect(testModule.stream is Stream<int>, true);
      expect(testModule.manual, false);
      expect(testModule.getActive() != null, true);
      expect(testModule.getActive().stream, testModule.stream);

      expect(testModule.stream, emits(100));
    });

    test('prioritization', () {
      SensorProvider testModule = new SensorProvider();
      var dumStreamA =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 100).take(5);
      SensorService testServiceA =
          new SensorService("Test Service A", 5, dumStreamA);
      testModule.add(testServiceA);

      var dumStreamB =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 250).take(5);
      SensorService testServiceB =
          new SensorService("Test Service B", 1, dumStreamB);
      testModule.add(testServiceB);

      var dumStreamC =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 500).take(5);
      SensorService testServiceC =
          new SensorService("Test Service C", 3, dumStreamC);
      testModule.add(testServiceC);

      expect(testModule.children.length, 3);
      expect(testModule.getWorkingList().length, 3);

      expect(testModule.children.indexOf(testServiceA), 2);
      expect(testModule.children.indexOf(testServiceB), 0);
      expect(testModule.children.indexOf(testServiceC), 1);
    });

    test('prioritization with no longer active', () {
      SensorProvider testModule = new SensorProvider();
      var dumStreamA =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 100).take(5);
      SensorService testServiceA =
          new SensorService("Test Service A", 5, dumStreamA);
      testModule.add(testServiceA);

      var dumStreamB =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 300).take(5);
      SensorService testServiceB =
          new SensorService("Test Service B", 1, dumStreamB);
      testModule.add(testServiceB);

      var dumStreamC =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 500).take(5);
      SensorService testServiceC =
          new SensorService("Test Service C", 3, dumStreamC);
      testModule.add(testServiceC);

      expect(testModule.children.length, 3);
      expect(testModule.getWorkingList().length, 3);

      expect(testModule.children.indexOf(testServiceB), 0);

      testServiceB.working = false;

      expect(testModule.getWorkingList().length, 2);
      expect(testModule.getActive(), testServiceC);
      expect(testModule.stream, emits(300));
    });

    test('manually set service', () {
      SensorProvider testModule = new SensorProvider();
      var dumStreamA =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 100).take(5);
      SensorService testServiceA =
          new SensorService("Test Service A", 5, dumStreamA);
      testModule.add(testServiceA);

      var dumStreamB =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 300).take(5);
      SensorService testServiceB =
          new SensorService("Test Service B", 1, dumStreamB);
      testModule.add(testServiceB);

      var dumStreamC =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 500).take(5);
      SensorService testServiceC =
          new SensorService("Test Service C", 3, dumStreamC);
      testModule.add(testServiceC);

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
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 100).take(5);
      SensorService testServiceA =
          new SensorService("Test Service A", 5, dumStreamA);
      testModule.add(testServiceA);

      var dumStreamB =
          Stream<int>.periodic(Duration(microseconds: 100), (x) => 300).take(5);
      SensorService testServiceB =
          new SensorService("Test Service B", 1, dumStreamB);
      testModule.add(testServiceB);

      testServiceB.working = false;
      testServiceB.stream = null;

      await Future.delayed(const Duration(microseconds: 200), () {});
      expect(testModule.manual, false);
      expect(testModule.stream, emits(100));
    });
  });
}
