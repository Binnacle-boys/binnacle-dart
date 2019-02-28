
import 'package:flutter/material.dart';
import 'CompassFace.dart';

class CompassBody extends StatelessWidget {
  CompassBody();

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
            //Other widgets in stack go here like Wind arrows, etc.
          ],
        )

    );
  }
}