import 'package:flutter/material.dart';
import 'dart:async';
import 'ui/CompassHeadingUI.dart';

class CompassHeadingWidget extends StatefulWidget {
  CompassHeadingWidget({Key key, this.directionStream, this.color})
      : super(key: key);

  final Stream<double> directionStream;
  final Color color;

  @override
  _CompassHeadingWidgetState createState() => _CompassHeadingWidgetState();
}

class _CompassHeadingWidgetState extends State<CompassHeadingWidget> {
  /// Stream subscription for direction
  StreamSubscription<double> _directionSubscription;
  StreamSubscription<double> get directionSubscription =>
      _directionSubscription;
  double _direction;
  Color _color;

  @override
  void initState() {
    super.initState();

    /// Set call back to the listener
    _directionSubscription = widget.directionStream?.listen(updateDirection);
    _color = widget.color;
  }

  /// Updates direction; callback for the direction stream subscription
  void updateDirection(double direction) {
    setState(() {
      print("wind widget direction: " + direction.toString());
      _direction = direction;
    });
  }

  /// Building UI component for the compass
  @override
  Widget build(BuildContext context) {
    return new CompassHeadingUI(heading: _direction, color: _color);
  }
}
