import 'package:flutter/material.dart';
import 'dart:async';
import 'ui/BinnacleHeadingUI.dart';

class BinnacleHeadingWidget extends StatefulWidget {
  BinnacleHeadingWidget({Key key, this.directionStream, this.color})
      : super(key: key);

  final Stream<double> directionStream;
  final Color color;

  @override
  _BinnacleHeadingWidgetState createState() => _BinnacleHeadingWidgetState();
}

class _BinnacleHeadingWidgetState extends State<BinnacleHeadingWidget> {
  StreamSubscription<double> _directionSubscription;
  StreamSubscription<double> get directionSubscription =>
      _directionSubscription;

  double _direction = 0;
  Color _color;

  @override
  void initState() {
    super.initState();

    /// Set call back to the listener
    _directionSubscription = widget.directionStream.listen(updateDirection);

    _color = widget.color;
  }

  /// Updates direction; callback for the direction stream subscription
  void updateDirection(double direction) {
    setState(() {
      // TODO: If the stream is null, show a toast saying failed to display it
      this._direction = direction;
    });
  }

  /// Building UI component for the compass
  @override
  Widget build(BuildContext context) {
    return new BinnacleHeadingUI(); //heading: _direction, color: _color);
  }
}
