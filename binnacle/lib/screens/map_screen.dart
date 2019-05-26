import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sos/enums.dart';
import 'package:sos/models/position_model.dart';
import 'package:sos/providers/app_provider.dart';
import 'package:sos/bloc.dart';

const int MAX_MARKERS = 1;

class MapScreen extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  bool placingPoints = false;
  bool _init = false;
  Bloc bloc;

  List<LatLng> course = new List();
  Map<PolylineId, Polyline> lines;
  List<Marker> markers;
  LatLng currentPosition;
  var _context;

  @override
  void dispose() {
    bloc.lines = lines;
    bloc.markers = markers;
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of(context);
    lines = bloc.lines;
    markers = bloc.markers;

    bloc.navigationEventBus.listen((event) {
      if (event?.eventType == NavigationEventType.start) {
        if (course.isEmpty) {
          print('Initializing course using the BLOC');
          course = bloc.getCourse();
          _initCourse(course, Colors.red);
        }
      } else if (event?.eventType == NavigationEventType.finish) {
        print('we need to display the other course');
        ReplaySubject<PositionModel> historyStream = bloc.courseHistory;
        List<LatLng> sailedCourse;
        historyStream.listen((position) => sailedCourse.add(position.latlng));

        print('Display finished course');
        _initCourse(sailedCourse, Colors.green);
      }
    });

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
                markers: Set<Marker>.of(markers),
                polylines: Set<Polyline>.of(lines.values),
              );
            }
          }),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          setState(() {
            placingPoints = !placingPoints;
          });

          if (placingPoints) {
            // Clear the current marker list
            Marker start = markers.elementAt(0);
            markers.clear();
            markers.add(start);

            // Clear the current course
            lines.clear();
          } else {
            _onCourseCreationFinished(bloc);
          }
        },
        child: placingPoints
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
    markers.add(Marker(
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
    if (!placingPoints) {
      return;
    }

    if (markers.length > MAX_MARKERS) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Max number of markers added"),
      ));

      return;
    }

    // TODO: Use a custom icon instead of the default Google Map one
    Marker marker = new Marker(
        markerId: MarkerId(markers.length.toString()),
        position: position,
        icon: BitmapDescriptor.defaultMarker);

    setState(() {
      markers.add(marker);
    });
  }

  void _onCourseCreationFinished(Bloc bloc) {
    if (markers.length < 2) {
      return;
    }

    List<LatLng> points = new List();
    markers.forEach((marker) => points.add(marker.position));

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

      PolylineId lineId = PolylineId(i.toString());
      Polyline line = Polyline(
          polylineId: lineId, color: lineColor, width: 15, points: [from, to]);

      setState(() {
        lines[lineId] = line;
      });
    }

    bloc.lines = lines;
  }
}
