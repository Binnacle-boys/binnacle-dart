import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sail_routing_dart/route_model.dart';
import 'package:sos/enums.dart';
import 'package:sos/models/position_model.dart';
import 'package:sos/models/wind_model.dart';
import 'package:vector_math/vector_math.dart';

class NavigationProvider {
  Stream _position;
  Stream _wind;
  Vector2 _start;
  Vector2 _end;
  RouteModel _route;
  BehaviorSubject<NavigationEvent> eventBus = BehaviorSubject();
  ReplaySubject<PositionModel> positionHistory;

  List<LatLng> course;

  NavigationProvider({@required position, @required wind}) {
    _position = position;
    _wind = wind;

    eventBus.add(NavigationEvent(eventType: NavigationEventType.init));
  }

  start(LatLng start, LatLng end) {
    /// NOTE: naive to assume long = x, lat = y, but it's close enough
    /// A better implementation would utilize the Haversine formula
    /// Which IMO should be done in the algorithm
    _start = Vector2(start.longitude, start.latitude);
    _end = Vector2(end.longitude, end.latitude);

    eventBus
        .add(NavigationEvent(eventType: NavigationEventType.calculatingRoute));

    _route = new RouteModel(start: _start, end: _end, wind_radians: 0);
    // new RouteModel(start: _start, end: _end, wind_radians: currentWind.deg);

    course = List();
    course.add(start);
    _route.intermediate_points.forEach((point) {
      course.add(new LatLng(point.y, point.x));
    });
    course.add(end);

    print('Route generated');
    print(_route);

    eventBus.add(NavigationEvent(eventType: NavigationEventType.start));

    positionHistory = new ReplaySubject<PositionModel>();
    positionHistory.addStream(_position);

    // TODO: Nick when producing the finish event, we need to run this line
    // positionHistory.close();

    // TODO: Convert this to a stack implementation
    // We don't want this clear to be pushed if a new event arrived in the bus
    Future.delayed(Duration(seconds: 5), () => eventBus.add(NavigationEvent(eventType: NavigationEventType.init)));
  }
}

class NavigationEvent {
  final NavigationEventType eventType;
  NavigationEvent({@required this.eventType});
}
