import 'package:flutter/material.dart';

import  'package:geolocator/geolocator.dart';


class SpeedWidget extends StatelessWidget {
  
  final Position speed; //String just for now, needs to be updated to Stream<Position>
  SpeedWidget(this.speed);

  @override
  Widget build(BuildContext context) {
    return Text(speed.toString());
  }
}
