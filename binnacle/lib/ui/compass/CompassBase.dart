import 'package:flutter/material.dart';
import 'CompassFace.dart';

import 'package:sos/model/Wind.dart';
import 'package:sos/model/Boat.dart';
import 'package:sos/CompassHeadingWidget.dart';

class CompassBase extends StatelessWidget {
  final Boat currentBoat;
  final Boat idealBoat;
  final Wind wind;

  CompassBase(this.currentBoat, this.idealBoat, this.wind);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
        aspectRatio: 1.0,
        child: new Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
            new CompassFace(),
            new CompassHeadingWidget(
                directionStream: wind.direction?.stream,
                color: Colors.lightBlue),
//            new CompassHeadingWidget(
//                directionStream: idealBoat.compassHeading.stream,
//                color: Colors.green),
//            new CompassHeadingWidget(
//                directionStream: currentBoat.compassHeading?.stream,
//                color: Colors.black12)
            //Other widgets in stack go here like Wind arrows, etc.
          ],
        ));
  }
}
