import 'package:flutter/material.dart';
import 'dart:async';
import 'ui/CompassUI.dart';
class CompassWidget extends StatefulWidget {
  CompassWidget({Key key, this.directionStream}) : super(key: key);
  
  final Stream<double> directionStream;

  @override
  _CompassWidgetState createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget> {
  
  /// Stream subscription for direction
  StreamSubscription<double> _directionSubscription;
  StreamSubscription<double> get directionSubscription => _directionSubscription;
  double _direction;

  @override
  void initState() {
    super.initState();
    /// Set call back to the listener
    _directionSubscription = widget.directionStream?.listen(updateDirection);
  }

  /// Updates direction; callback for the direction stream subscription
  void updateDirection (double direction) {
    _direction = direction;
  }

  /// Building UI component for the compass
  @override
  Widget build(BuildContext context) {
   return new CompassUI(direction: _direction); 
  }
  

}