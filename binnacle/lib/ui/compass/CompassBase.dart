import 'package:flutter/material.dart';
import 'CompassFace.dart';

import 'package:sos/model/Wind.dart';
import 'package:sos/model/Boat.dart';
import 'package:sos/WindDirectionWidget.dart';

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
            new WindDirectionWidget(directionStream: wind.direction.stream)
            //Other widgets in stack go here like Wind arrows, etc.
          ],
        ));
  }
}
