import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:sail_routing_dart/route_model.dart';
import 'package:sail_routing_dart/polar_plotting/polar_plot.dart';
import 'package:sail_routing_dart/polar_algs/polar_router.dart';
import 'package:sail_routing_dart/shared/route_math.dart';
import 'package:sos/models/position_model.dart';
import 'package:sos/models/wind_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sos/enums.dart';

const metersPerDegree = 111111;

/// Navigation Provider handles new positions and route calculations. 
/// Every position change checks if a new event needs to be emitted or if the route needs to be recalculated.
class NavigationProvider {
  
  BehaviorSubject<PositionModel> _position;
  // Position for cancelling listener when necessary.
  StreamSubscription<PositionModel> _positionSub;
  
  BehaviorSubject<WindModel> _wind;
  WindModel _windModel;
  
  Vector2 _start;
  Vector2 _end;
  
  RouteModel _route;
  PolarPlot _plot;
  
  double _currentIdealHeading;
  BehaviorSubject<double> idealHeading;
  
  int _currentCheckPoint;

  NavigationEvent _currentEvent;
  BehaviorSubject<NavigationEvent> eventBus;

  double _closeEnough = (1 / metersPerDegree) * 25; // 25 meters
  double get closeEnough => _closeEnough;
  
  NavigationProvider({@required BehaviorSubject<PositionModel> position, @required BehaviorSubject<WindModel> wind, @required PolarPlot plot}) {
    _position = position;
    _wind = wind;
    _plot = plot;
    eventBus = BehaviorSubject<NavigationEvent>(sync: true);
    idealHeading = BehaviorSubject<double>();
    // eventBus.add(NavigationEvent(eventType: NavigationEventType.awaitingInit ));
  }

  /// Used to initialize new course
  /// Args:
  ///   (LatLng) start: Start of the course, usually the current location
  ///   (LatLng) end: Where the user wants to go.
  /// Returns:
  ///   Nothing, async
  Future start(LatLng start, LatLng end) async {
    _updateEventBus(NavigationEventType.calculatingRoute);
    _start = Vector2(start.longitude, start.latitude);
    _end = Vector2(end.longitude, end.latitude);
    print("About to get wind!");
    // Gets most recent wind entry
    _windModel = await _wind.firstWhere((w) {return (w != null);});
    _initRoute(_plot, _start, _end, _windModel);
    _currentCheckPoint = 0;
    _positionSub = await _position.listen(_navigate);
  }

  /// Sets close enough with the meter as units. Will be converted to lat/long degrees
  /// Args:
  ///   (double) meters : Close enough for finish or tacks in meters
  /// Returns:
  ///   void
  void setCloseEnough(double meters) {
    if (meters < 0) {
      // Don't accept negative numbers
      return;
    }
    _closeEnough = meters / metersPerDegree;
  }

  /// Navigate function called on the change of the position of the boat.
  /// Args:
  ///   pos (PositionModel): The boat's new/current position
  /// Returns:
  ///   Nothing, updates internal information
  void _navigate(PositionModel pos) {
    print("New position ${pos.lat} ${pos.lon}");
    print("Current Checkpoint: ${_currentCheckPoint}");
    Vector2 posVec = Vector2(pos.lon, pos.lat);
    if (_currentCheckPoint == 0) {
      // Route starting
      _currentCheckPoint = 1; 
      // Update event bus to trigger the start of the route
      _updateEventBus(NavigationEventType.start);
      
    }
    if (posVec.distanceTo(_end) < _closeEnough) {
      // Finish!
      //Push event
      eventBus.add(NavigationEvent(eventType: NavigationEventType.finish)); 
      // Canceling position listener
      _positionSub?.cancel(); // This may not work
      return;
    }
    if (_shouldTack(pos, _route.intermediate_points[_currentCheckPoint])) {
      // User should tack
      // Update Checkpoint
      _currentCheckPoint++;
      // Update Event bus to tack
      _updateEventBus(NavigationEventType.tackNow);
      // Update new ideal heading for next checkpoint
      _updateIdeal(_route.intermediate_points[_currentCheckPoint - 1], _route.intermediate_points[_currentCheckPoint]);
      return;
    }
    //If off course
    //start(LatLng(posVec.y, posVec.x), LatLng(_end.y, _end.x));
    // Some extra if statement to check if it is off course
  }

  /// Sets up new route with start end, current wind, and plot.
  void _initRoute(PolarPlot plot, Vector2 start, Vector2 end, WindModel wind) {
    _route = calculateRoute(plot, start, end, wind);
    _updateIdeal(start, _route.intermediate_points[1]);
  }

  /// Gets a route from start, end, plot and wind.
  /// Args:
  ///   (PolarPlot) plot: A polar plot of the boat in use.
  ///   (Vector2) start: The start point.
  ///   (Vector2) end: An end point for the route.
  ///   (WindModel) wind: current wind.
  /// Returns:
  ///   (RouteModel) - A route calculated 
  RouteModel calculateRoute(PolarPlot plot, Vector2 start, Vector2 end, WindModel wind) {
    PolarRouter pr = PolarRouter(plot);
    var points = pr.getTransRoute(start.storage.toList(), end.storage.toList(), wind.speed, wind.deg);
    var rm = RouteModel(start: start, end: end, wind_radians: degToRad(cardinalTransform(wind.deg)));
    List<Vector2> pointVectors = List<Vector2>();
    for (var point in points) {
      pointVectors.add(Vector2(point[0], point[1]));
    }
    rm.intermediate_points = pointVectors;
    return rm;
  }

  /// Get direction from a start and an end point
  /// Args:
  ///   (Vector2) start: First point
  ///   (Vector2) end: Second point - not necessarily the last point in a route, just segment
  /// Returns:
  ///   (double) - Cardinal direction in degrees
  double _getDirection(Vector2 start, Vector2 end) {
    Vector2 idealRoute = end - start;
    double radianAngle = atan2(idealRoute.y, idealRoute.x);
    return radiansToCardinal(radianAngle);
  }

  /// Determines if user should tack based on their objective/nextCheckpoint.
  /// Args:
  ///   (PositionModel) pos - Current position of the user.
  ///   (Vector2) nextCheckpoint - Next objective.
  bool _shouldTack(PositionModel pos, Vector2 nextCheckpoint) {
    return nextCheckpoint.distanceTo(Vector2(pos.lon, pos.lat)) < _closeEnough;
  }

  /// Update the event bus.
  /// Args:
  ///   (NavigationEventType): Event that occurred.
  /// Returns:
  ///   Nothing, but updates event bus to listeners. 
  void _updateEventBus(NavigationEventType event) {
    _currentEvent = NavigationEvent(eventType: event);
    eventBus.add(_currentEvent);
  }

  void _updateIdeal(Vector2 start, Vector2 end) {
    // Get ideal from start and end point
    _currentIdealHeading = _getDirection(start, end);
    // Update Ideal heading stream
    idealHeading.add(_currentIdealHeading);
  }

  /// Gets current course. Should only be called on start event.
  /// Args: 
  ///   None.
  /// Returns:
  ///   (List<LatLng>) List of Lat/Long coordinates in rote
  List<LatLng> getCourse() {
    if(_route == null) {
      return null;
    }
    List<LatLng> course = List<LatLng>();
    for (Vector2 point in _route.intermediate_points) {
      course.add(LatLng(point.y, point.x));
    }
    return course;
  }

  


}

class NavigationEvent {
  final NavigationEventType eventType;
  NavigationEvent({@required this.eventType});
  
}
