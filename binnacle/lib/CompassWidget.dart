import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sos/ui/CompassUI.dart';
import 'package:sos/model/DataModel.dart';

class CompassWidget extends StatefulWidget {
  CompassWidget({Key key, this.model}) : super(key: key);

  final DataModel model;

  @override
  _CompassWidgetState createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget> {
  /// Stream subscription for direction
  StreamSubscription<double> _directionSubscription;
  StreamSubscription<double> get directionSubscription =>
      _directionSubscription;
  double _direction;

  @override
  void initState() {
    super.initState();

    /// Set call back to the listener
    _directionSubscription =
        widget.model.currentBoat.compassHeading.stream.listen(updateDirection);
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
    return new CompassUI(
        currentBoat: widget.model.currentBoat,
        idealBoat: widget.model.idealBoat,
        wind: widget.model.wind,
        direction: _direction);
  }
}
