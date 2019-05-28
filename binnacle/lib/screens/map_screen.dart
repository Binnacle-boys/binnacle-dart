import 'dart:async';
import 'dart:math';
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
  Bloc bloc;

  List<LatLng> course = new List();
  Map<PolylineId, Polyline> lines;
  List<Marker> markers;
  LatLng currentPosition;
  BuildContext _context;

  StreamSubscription eventBusListener;

  @override
  void dispose() {
    bloc.lines = lines;
    bloc.markers = markers;

    eventBusListener.cancel();
    eventBusListener = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of(context);
    lines = bloc.lines;
    markers = bloc.markers;
    print("Building!!!!");
    eventBusListener ??= bloc.navigationEventBus.listen((event) {
      if (event?.eventType == NavigationEventType.start) {
        print('Initializing course using the BLOC');
        course = bloc.getCourse();
        bloc.originalCourse = bloc.getCourse();
        _initCourse(course, Colors.red);
      } else if (event?.eventType == NavigationEventType.finish) {
        if (bloc.sailedCourse.isNotEmpty) {
          return;
        }

        /// NOTE: Show the original course the sailor was supposed to sail
        course = bloc.originalCourse;

        ReplaySubject<PositionModel> historyStream = bloc.courseHistory;
        List<LatLng> sailedCourse = List();
        double fastestSpeed = 0;
        double averageSpeed = 0;
        int count = 0;
        historyStream.values.forEach((position) {
          fastestSpeed = max(fastestSpeed, position.speed);
          averageSpeed += position.speed;
          count++;
          sailedCourse.add(position.latlng);
        });

        averageSpeed = averageSpeed / count;
        print("Fastest speed on this course was $fastestSpeed");
        print("Average speed on this course was $averageSpeed");

        bloc.sailedCourse = sailedCourse;
        _drawCourse();
      } else if (event?.eventType == NavigationEventType.courseUpdated) {
        course = bloc.getCourse();
        _initCourse(course, Colors.red);
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
              _updateStartMarker(snapshot.data.latlng);

              return GoogleMap(
                onMapCreated: _onMapCreated,
                onTap: _onMapTapped,
                mapType: MapType.satellite,
                myLocationEnabled: true,
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
            setState(() {
              // Clear the current course
              lines.clear();

              Marker start = markers.elementAt(0);
              markers.clear();
              markers.add(start);
            });
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

  void _updateStartMarker(LatLng startPosition) {
    Marker start = Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId("Start"),
      position: startPosition,
      infoWindow: InfoWindow(title: 'Starting point'),
      // NOTE: Marker is originally red, we need hue to change it to green
      icon: BitmapDescriptor.defaultMarkerWithHue(114),
    );

    if (markers.isEmpty) {
      markers.add(start);
    } else {
      markers[0] = start;
    }
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
    //print('initializing course');
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

  void _drawCourse() {
    lines.clear();
    markers.clear();

    for (int i = 0; i < bloc.originalCourse.length - 1; i++) {
      LatLng from = bloc.originalCourse.elementAt(i);
      LatLng to = bloc.originalCourse.elementAt(i + 1);

      PolylineId lineId = PolylineId(i.toString());
      Polyline line = Polyline(
          polylineId: lineId, color: Colors.red, width: 15, points: [from, to]);

      setState(() {
        lines[lineId] = line;
      });
    }

    for (int i = 0; i < bloc.sailedCourse.length - 1; i++) {
      LatLng from = bloc.sailedCourse.elementAt(i);
      LatLng to = bloc.sailedCourse.elementAt(i + 1);

      PolylineId lineId =
          PolylineId((bloc.originalCourse.length + i).toString());
      Polyline line = Polyline(
          polylineId: lineId,
          color: Colors.green,
          width: 15,
          points: [from, to]);

      setState(() {
        lines[lineId] = line;
      });
    }
  }
}
