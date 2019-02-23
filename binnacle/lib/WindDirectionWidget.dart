import 'package:flutter/material.dart';
import 'dart:async';
import 'ui/CompassUI.dart';
import 'ui/WindDirectionUI.dart';

class WindDirectionWidget extends StatefulWidget {
  WindDirectionWidget({Key key, this.directionStream}) : super(key: key);

  final Stream<double> directionStream;

  @override
  _WindDirectionWidgetState createState() => _WindDirectionWidgetState();
}

class _WindDirectionWidgetState extends State<WindDirectionWidget> {
  /// Stream subscription for direction
  StreamSubscription<double> _directionSubscription;
  StreamSubscription<double> get directionSubscription =>
      _directionSubscription;
  double _direction;

  @override
  void initState() {
    super.initState();

    /// Set call back to the listener
    _directionSubscription = widget.directionStream?.listen(updateDirection);
  }

  /// Updates direction; callback for the direction stream subscription
  void updateDirection(double direction) {
    setState(() {
      _direction = direction;
    });
  }

  /// Building UI component for the compass
  @override
  Widget build(BuildContext context) {
    return new WindDirectionUI(heading: _direction);
  }
}
