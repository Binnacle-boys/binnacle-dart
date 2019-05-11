import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sail_routing_dart/cart_point.dart';
import 'package:sail_routing_dart/route_model.dart';
import 'package:sos/models/position_model.dart';
import 'package:sos/enums.dart';

class NavigationProvider {
  Stream _position;
  Stream _wind;
  CartPoint _start;
  CartPoint _end;
  RouteModel _route;
  BehaviorSubject eventBus = BehaviorSubject();


  NavigationProvider({@required position, @required wind}) {
    _position = position;
    _wind = wind;
    eventBus.add(NavigationEvent(eventType: NavigationEventType.awaitingInit ));
  }
  initNavigation() {
    print('!!! FROM INITNAV');
    eventBus.add(NavigationEvent(eventType: NavigationEventType.init));


  }


  // start(PositionModel start, PositionModel end) {
  //   _start = _positionToCartPoint(start);
  //   _end = _positionToCartPoint(end);


  // }
  // RouteModel calculateRoute(start, end) {

  // }

  // _positionToCartPoint(p) => CartPoint(p.lat, p.lon);
  // _cartPointToPosition(c) => PositionModel(lat: c.x, lon: c.y, speed: 0.0);


}

class NavigationEvent {
  final NavigationEventType eventType;
  NavigationEvent({@required this.eventType});
  
}
