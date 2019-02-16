import 'package:flutter/material.dart';

import  'package:geolocator/geolocator.dart';

class SpeedWidget extends StatelessWidget {
  
  Position _position;
  SpeedWidget(this._position);

  @override
  Widget build(BuildContext context) {
    return Text(_position.speed.toString());
  }
}
