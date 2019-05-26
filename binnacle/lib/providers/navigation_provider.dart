import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:sail_routing_dart/route_model.dart';
import 'package:sail_routing_dart/polar_plotting/polar_plot.dart';
import 'package:sail_routing_dart/polar_algs/polar_router.dart';
import 'package:sail_routing_dart/shared/route_math.dart';
import 'package:sos/models/position_model.dart';
import 'package:sos/models/ideal_heading_model.dart';
import 'package:sos/models/wind_model.dart';
import 'package:sos/enums.dart';
import 'package:flutter/services.dart' show rootBundle;

// How many meters are in one degree of lat/long
const metersPerDegree = 111111;
// Defaults to value checks for navigating. The actual values can be changed at runtime.
const defaultMaxOffset = 25.0;
const defaultCloseEnough = 25.0;
/// Navigation Provider handles new positions and route calculations.
/// Every position change checks if a new event needs to be emitted or if the route needs to be recalculated.
class NavigationProvider {
  Stream<PositionModel> _position;
  // Position for cancelling listener when necessary.
  StreamSubscription<PositionModel> _positionSub;

  BehaviorSubject<WindModel> _wind;
  WindModel _windModel;

  Vector2 _start;
  Vector2 _end;

  RouteModel _route;
  PolarPlot _plot;

  double _currentIdealHeading;
  BehaviorSubject<IdealHeadingModel> idealHeading;

  int _currentCheckPoint;

  NavigationEvent _currentEvent;
  BehaviorSubject<NavigationEvent> eventBus;
  ReplaySubject<PositionModel> positionHistory;

  
  double _closeEnough = (1 / metersPerDegree) * defaultCloseEnough; // 25 meters
  
  /// Gets the current closeEnough value in meters.
  /// Returns:
  ///   (double) Close enough value (meters) to trigger finishes or tacks.
  double get closeEnough => _closeEnough * metersPerDegree;

  
  double _maxOffset = (1 / metersPerDegree) * defaultMaxOffset; // 25 meters
  
  /// Gets the current max offset value in meters.
  /// Returns:
  ///   (double) Max offset value (meters) to trigger off course value
  double get maxOffset => _maxOffset * metersPerDegree;

  NavigationProvider(
      {@required Stream<PositionModel> position,
      @required BehaviorSubject<WindModel> wind,
      PolarPlot plot}) {
    _position = position;
    _wind = wind;
    print("Printing plot!");
    print(plot);
    _plot = plot;
    eventBus = BehaviorSubject<NavigationEvent>(sync: true);
    idealHeading = BehaviorSubject<IdealHeadingModel>();
  }

  /// Used to initialize new course
  /// Args:
  ///   (LatLng) start: Start of the course, usually the current location
  ///   (LatLng) end: Where the user wants to go.
  /// Returns:
  ///   Nothing, async
  Future start(LatLng start, LatLng end) async {
    if (_plot == null) {
      // Set up polar plot
      print("Plot was null!");
      await _initPolarPlot();
    }
    _updateEventBus(NavigationEventType.calculatingRoute);
    _start = Vector2(start.longitude, start.latitude);
    _end = Vector2(end.longitude, end.latitude);
    print("About to get wind!");
    // Gets most recent wind entry
    _windModel = await _wind.firstWhere((w) {
      return (w != null);
    });
    print("Got wind!");
    _initRoute(_plot, _start, _end, _windModel);
    print("About to get position history");
    /// Record the position history now that we have a course
    positionHistory = new ReplaySubject<PositionModel>();

    _currentCheckPoint = 0;
    print("About to start listener");
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

  /// Sets max offset value in meters. Will be converted to lat/long. Used to check if boat is off course.
  /// Args:
  ///   (double) meters: Max offset in meters. How off the boat can be from the course.
  void setMaxOffset(double meters) {
    if (meters < 0) {
      return;
    }
    _maxOffset = meters / metersPerDegree;
  }

  /// Navigate function called on the change of the position of the boat.
  /// Args:
  ///   pos (PositionModel): The boat's new/current position
  /// Returns:
  ///   Nothing, updates internal information
  Future<void> _navigate(PositionModel pos) async {
    positionHistory.add(pos);
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
      //eventBus.add(NavigationEvent(eventType: NavigationEventType.finish));
      _updateEventBus(NavigationEventType.finish);
      /// Stop recording position now that the course is finished
      await positionHistory.close();

      // Canceling position listener
      await _positionSub?.cancel(); // This may not work
      return;
    }
    if (_shouldTack(pos, _route.intermediate_points[_currentCheckPoint])) {
      // User should tack
      // Update Checkpoint
      _currentCheckPoint++;
      // Update Event bus to tack
      _updateEventBus(NavigationEventType.tackNow);
      // Update new ideal heading for next checkpoint
      _updateIdeal(_route.intermediate_points[_currentCheckPoint - 1],
          _route.intermediate_points[_currentCheckPoint]);
      return;
    }
    //If off course
    //start(LatLng(posVec.y, posVec.x), LatLng(_end.y, _end.x));
    // Some extra if statement to check if it is off course
    _handleOffCourse(posVec, _currentCheckPoint);
  }

  Future _initPolarPlot() async {
    print("Initializing polar plot");
    String csv = await rootBundle.loadString("assets/polar_plots/test_plot.csv");
    _plot = PolarPlot();
    _plot.initStream(csv);
  }
  /// Sets up new route with start end, current wind, and plot.
  void _initRoute(PolarPlot plot, Vector2 start, Vector2 end, WindModel wind) {
    _route = _calculateRoute(plot, start, end, wind);
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
  RouteModel _calculateRoute(
      PolarPlot plot, Vector2 start, Vector2 end, WindModel wind) {
    PolarRouter pr = PolarRouter(plot);
    var points = pr.getTransRoute(
        start.storage.toList(), end.storage.toList(), wind.speed, wind.deg);
    var rm = RouteModel(
        start: start,
        end: end,
        wind_radians: degToRad(cardinalTransform(wind.deg)));
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

  Future<void> _handleOffCourse(Vector2 current, int currentCheckpoint) {
    Vector2 nextCheckpoint = _route.intermediate_points[currentCheckpoint];
    Vector2 prevCheckpoint = _route.intermediate_points[currentCheckpoint - 1];

    Vector2 reverseIdealPath = prevCheckpoint - nextCheckpoint;
    Vector2 reverseRealPath = current - nextCheckpoint;
    
    double angle = reverseRealPath.angleTo(reverseIdealPath);
    double offset = sin(angle) * reverseRealPath.length;

    if (angle > pi/2) {
      // Some how past tack point
      // Recalculate
      return start(LatLng(current.y, current.x), LatLng(_end.y, _end.x));
    }
    if (offset > maxOffset) {
      return start(LatLng(current.y, current.x), LatLng(_end.y, _end.x));
    }

  }

  /// Update the event bus.
  /// Args:
  ///   (NavigationEventType): Event that occurred.
  /// Returns:
  ///   Nothing, but updates event bus to listeners.
  void _updateEventBus(NavigationEventType event) {
    _currentEvent = NavigationEvent(eventType: event);
    eventBus.add(_currentEvent);

    if (event == NavigationEventType.start) {
      print("START EVENT!!!");
      // TODO: Convert this to a stack implementation
      // We don't want this clear to be pushed if a new event arrived in the bus
      Future.delayed(
          Duration(seconds: 5),
          () => eventBus
              .add(NavigationEvent(eventType: NavigationEventType.init)));
    }
  }

  void _updateIdeal(Vector2 start, Vector2 end) {
    // Get ideal from start and end point
    _currentIdealHeading = _getDirection(start, end);
    // Update Ideal heading stream

    idealHeading.add(IdealHeadingModel(direction: _currentIdealHeading));
  }

  /// Gets current course. Should only be called on start event.
  /// Args:
  ///   None.
  /// Returns:
  ///   (List<LatLng>) List of Lat/Long coordinates in rote
  List<LatLng> getCourse() {
    if (_route == null) {
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
