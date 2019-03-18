import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sos/ui/BinnacleUI.dart';
import 'package:sos/model/DataModel.dart';

class BinnacleWidget extends StatefulWidget {
  BinnacleWidget({Key key, this.model}) : super(key: key);

  final DataModel model;

  @override
  _BinnacleWidgetState createState() => _BinnacleWidgetState();
}

class _BinnacleWidgetState extends State<BinnacleWidget> {
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
    return new BinnacleUI(
        currentBoat: widget.model.currentBoat,
        idealBoat: widget.model.idealBoat,
        wind: widget.model.wind,
        direction: _direction);
  }
}
