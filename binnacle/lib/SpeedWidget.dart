import 'package:flutter/material.dart';
import 'dart:async';
import  'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class SpeedWidget extends StatefulWidget {
  SpeedWidget({Key key, this.positionStream}) : super(key: key);

  final Stream<Position> positionStream;

  @override
  _SpeedWidgetState createState() => _SpeedWidgetState();
}

class _SpeedWidgetState extends State<SpeedWidget> {
  
  /// In case streamsubscription needs to be managed
  StreamSubscription<Position> _positionSub;
  StreamSubscription<Position> get positionSub => _positionSub;
  
  Position _position;
  NumberFormat speedFormat;

  @override
  void initState() {
    super.initState();
    //Set listen to updatePosition call
    _positionSub = widget.positionStream.listen(updatePosition);
    // Setting up a standard format for speed
    // TODO: Use a static class for these formats in future
    speedFormat = new NumberFormat("##0.0#", "en_US");
  }

  /// Assigned to the listener to update the state of this widget
  void updatePosition(Position position) {
    setState(() {
      _position = position;
    });
  }

  /// Converts meters per second to miles per hour
  double msToMph(double msSpeed) {
    return msSpeed * 2.23694;
  }

  /// Creates a string to display for the speed
  String speedString(Position pos) {
    if(pos == null) {
      //When no position found, may need to be changed later
      return "Loading speed";
    }
    // TODO: Switch based on unit options  
    double mphSpeed = msToMph(pos.speed);
    return speedFormat.format(mphSpeed) + " mph";
  }

  @override
  Widget build(BuildContext context) {
    return Text(speedString(_position));
  }
}
