import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sos/providers/app_provider.dart';

class MapUI extends StatelessWidget {
  Completer<GoogleMapController> _controller = Completer();
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return StreamBuilder(
        stream: bloc.position,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading...");
          } else {
            _markers.add(Marker(
              // This marker id can be anything that uniquely identifies each marker.
              markerId: MarkerId("You Are Here".toString()),
              position: snapshot.data.latlng,
              infoWindow: InfoWindow(
                title: 'Mch',
                snippet: 'Its meh',
              ),
              icon: BitmapDescriptor.defaultMarker,
            ));
            return Stack(children: [
              GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: snapshot.data.latlng,
                    zoom: 15.0,
                  ),
                  markers: _markers,
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: true),
            ]);
          }
        });
  }
}

class MapWidget extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Maps Sample App'),
            backgroundColor: Colors.green[700],
          ),
          body: MapUI()),
    );
  }
}
