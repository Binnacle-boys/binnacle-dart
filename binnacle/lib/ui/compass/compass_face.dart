import 'package:flutter/material.dart';
import 'package:sos/ui/BinnacleHeadingUI.dart';
import 'CompassDialPainter.dart';

class CompassFace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(2.0),
      child: new AspectRatio(
        aspectRatio: 1.0,
        child: new Container(
          width: double.infinity,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).backgroundColor,
          ),
          child: new Stack(
            children: <Widget>[
              // dial and numbers go here
              //new CustomPaint(painter: ArrowPainter2()),
              new Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(1.0),
                child: new CustomPaint(
                  painter: new CompassDialPainter(td: Theme.of(context)),
                ),
              ),
              new BinnacleHeadingUI(),
              // centerpoint
              new Center(
                child: new Container(
                  width: 15.0,
                  height: 15.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
