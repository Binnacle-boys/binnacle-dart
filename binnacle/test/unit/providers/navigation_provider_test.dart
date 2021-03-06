import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:sos/models/position_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vector_math/vector_math.dart';
import 'package:sail_routing_dart/polar_plotting/polar_plot.dart';
import 'package:sos/providers/navigation_provider.dart';
import 'package:sos/models/wind_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sos/models/ideal_heading_model.dart';
import 'package:sos/enums.dart';
import 'dart:io';

void main() {
  BehaviorSubject<PositionModel> positionStream;
  LatLng start;
  LatLng end;
  PolarPlot plot;
  BehaviorSubject<WindModel> wind;
  print("PRINTING CURRENT DIRECTORY!!");
  print(Directory.current.path);
  setUp(() async {
    plot = PolarPlot();
    await plot.init('unit/providers/providerAssets/test_plot.csv');

    positionStream = BehaviorSubject<PositionModel>();
    wind = BehaviorSubject<WindModel>(sync: true);
  });

  test('Expect Wind stream to trigger calculation, and position to trigger start.', () async {
    print("Testing somethin");
    start = LatLng(0, 0);
    end = LatLng(10, 0);
    NavigationProvider np = NavigationProvider(position: positionStream, plot: plot, wind: wind);
    NavigationEvent boy;
    np.eventBus.listen((event) {
      print(event.eventType);
      if(event != null) {
        boy = event;
      }
    });
    wind.listen((w) => print(w.speed));
    await wind.add(WindModel(6.0, 180.0));
    await np.start(start, end);
    // Ensuring start got the wind
    await expectLater(boy.eventType, NavigationEventType.calculatingRoute);
    // Checking if the route started
    await positionStream.add(PositionModel(lat: start.latitude, lon: start.longitude, speed: 1.0));
    await expectLater(boy.eventType, NavigationEventType.start);
    
    
    
  });
  test('Expect event bus to get proper ideal heading and finish on arrival of end.', () async {
    print("Testing somethin");
    start = LatLng(0, 0);
    end = LatLng(10, 0);
    NavigationProvider np = NavigationProvider(position: positionStream, plot: plot, wind: wind);
    NavigationEvent boy;
    np.eventBus.listen((event) {
      print(event.eventType);
      if(event != null) {
        boy = event;
      }
    });
    await wind.add(WindModel(6.0, 180.0));
    await np.start(start, end);
    // Ensuring start got the wind
    // Checking if the route started
    await positionStream.add(PositionModel(lat: start.latitude, lon: start.longitude, speed: 1.0));
    await expectLater(boy.eventType, NavigationEventType.start);

    double headingBoy;
    // Test ideal
    await np.idealHeading.listen((heading) {
      headingBoy = heading.direction;
    });
    await expectLater(headingBoy, 316.1000012170191);
    await positionStream.add(PositionModel(lat: end.latitude, lon: end.longitude));
    await expectLater(boy.eventType, NavigationEventType.finish);     
  });

   test('Expect event bus to emit tack now event', () async {
    print("Testing somethin");
    start = LatLng(0, 0);
    end = LatLng(10, 0);
    NavigationProvider np = NavigationProvider(position: positionStream, plot: plot, wind: wind);
    NavigationEvent boy;
    np.eventBus.listen((event) {
      print(event.eventType);
      if(event != null) {
        boy = event;
      }
      if (event.eventType == NavigationEventType.start) {
        print(np.getCourse());
      }
    });
    await wind.add(WindModel(6.0, 180.0));
    await np.start(start, end);
    // Ensuring start got the wind
    // Checking if the route started
    await positionStream.add(PositionModel(lat: start.latitude, lon: start.longitude, speed: 1.0));
    await expectLater(boy.eventType, NavigationEventType.start);

    double headingBoy;
    // Test ideal
    await np.idealHeading.listen((heading) {
      headingBoy = heading.direction;
    });
    await expectLater(headingBoy, 316.1000012170191);
    var tackPoint = LatLng(4.999998569488525, -4.811605930328369);
    await positionStream.add(PositionModel(lat: tackPoint.latitude, lon: tackPoint.longitude));
    await expectLater(boy.eventType, NavigationEventType.tackNow);
    await expectLater(headingBoy, 43.89998240260968);     
  });
  test('Expect event bus to emit off course event', () async {
    print("Testing somethin");
    start = LatLng(0, 0);
    end = LatLng(10, 0);
    NavigationProvider np = NavigationProvider(position: positionStream, plot: plot, wind: wind);
    NavigationEvent boy;
    np.eventBus.listen((event) {
      print(event.eventType);
      if(event != null) {
        boy = event;
      }
      if (event.eventType == NavigationEventType.start) {
        print(np.getCourse());
      }
    });
    await wind.add(WindModel(6.0, 180.0));
    await np.start(start, end);
    // Ensuring start got the wind
    // Checking if the route started
    await positionStream.add(PositionModel(lat: start.latitude, lon: start.longitude, speed: 1.0));
    await expectLater(boy.eventType, NavigationEventType.start);

    double headingBoy;
    // Test ideal
    await np.idealHeading.listen((heading) {
      headingBoy = heading.direction;
    });
    await expectLater(headingBoy, 316.1000012170191);
    var tackPoint = LatLng(4.999998569488525, 4.811605930328369);
    print("Going to tack point");
    await positionStream.add(PositionModel(lat: tackPoint.latitude, lon: tackPoint.longitude));
    await expectLater(boy.eventType, NavigationEventType.offCourse);
    await Future.delayed(Duration(seconds: 1));
    await expectLater(boy.eventType, NavigationEventType.courseUpdated);
  });
}
