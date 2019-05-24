import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sos/enums.dart';
import 'package:sos/models/position_model.dart';
import 'package:sos/providers/app_provider.dart';
import 'package:sos/providers/navigation_provider.dart';

import '../bloc.dart';

const int MAX_MARKERS = 1;

class MapScreen extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapScreen> {
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  bool _isPlacingPoints = false;
  bool _init = false;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    bloc.navigationEventBus.listen((event) {
      if (event?.eventType == NavigationEventType.start) {
        print('Initializing course using the BLOC');
        _initCourse(bloc.course, Colors.red);
      } else if (event?.eventType == NavigationEventType.finish) {
        print('we need to display the other course');
        ReplaySubject<PositionModel> historyStream = bloc.courseHistory;
        List<LatLng> sailedCourse;
        historyStream.listen((position) => sailedCourse.add(position.latlng));

        print('Display finished course');
        _initCourse(sailedCourse, Colors.green);
      }
    });

    var _context;

    return MaterialApp(
        home: Scaffold(
      body: StreamBuilder(
          stream: bloc.position,
          builder: (context, snapshot) {
            _context = context;
            if (!snapshot.hasData) {
              return Center(
                child: new CircularProgressIndicator(),
              );
            } else {
              _initStartMarker(snapshot.data.latlng);

              return GoogleMap(
                onMapCreated: _onMapCreated,
                onTap: _onMapTapped,
                mapType: MapType.satellite,
                initialCameraPosition: CameraPosition(
                  target: snapshot.data.latlng,
                  zoom: 12.5,
                ),
                markers: _markers,
                polylines: Set<Polyline>.of(_polylines.values),
              );
            }
          }),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          setState(() {
            _isPlacingPoints = !_isPlacingPoints;
          });

          if (_isPlacingPoints) {
            // Clear the current marker list
            Marker start = _markers.elementAt(0);
            _markers.clear();
            _markers.add(start);

            // Clear the current course
            _polylines.clear();
          } else {
            _onCourseCreationFinished(bloc);
          }
        },
        child: _isPlacingPoints
            ? Icon(Icons.assistant_photo, size: 36.0)
            : Icon(Icons.add_location, size: 36.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }

  void _initStartMarker(LatLng startPosition) {
    if (_init) {
      // We already initialized the widget
      return;
    }

    _init = true;

    print('_initStartMarker');
    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId("Start"),
      position: startPosition,
      infoWindow: InfoWindow(title: 'Starting point', snippet: 'You are here'),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onMapTapped(LatLng position) {
    if (!_isPlacingPoints) {
      return;
    }

    if (_markers.length > MAX_MARKERS) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Max number of markers added"),
      ));

      return;
    }

    // TODO: Use a custom icon instead of the default Google Map one
    Marker marker = new Marker(
        markerId: MarkerId(_markers.length.toString()),
        position: position,
        onTap: _onMarkerTap,
        icon: BitmapDescriptor.defaultMarker);

    setState(() {
      _markers.add(marker);
    });
  }

  void _onMarkerTap() {
    print('the marker was tapped');
  }

  void _onCourseCreationFinished(Bloc bloc) {
    if (_markers.length < 2) return;

    List<LatLng> points = new List();
    _markers.forEach((marker) => points.add(marker.position));

    print(points);

    /// TODO: Only does the first set for now.
    /// Navigator needs to be upgraded to deal with a list of points
    /// to be able to handle complex courses
    bloc.startNavigation(points.elementAt(0), points.elementAt(1));
  }

  /// Constructs the polylines that will be shown on the map as the
  /// course to be sailed. Pretty much connects the dots
  /// List<LatLng> [points] are a list of geographical points
  /// returns void as it sets the current state to have these polylines
  void _initCourse(List<LatLng> points, Color lineColor) {
    for (int i = 0; i < points.length - 1; i++) {
      LatLng from = points.elementAt(i);
      LatLng to = points.elementAt(i + 1);

      int id = _polylines.keys.length;
      print(id);
      PolylineId lineId = PolylineId(id.toString());
      Polyline line = Polyline(
          polylineId: lineId, color: lineColor, width: 15, points: [from, to]);

      setState(() {
        _polylines[lineId] = line;
      });
    }
  }
}
