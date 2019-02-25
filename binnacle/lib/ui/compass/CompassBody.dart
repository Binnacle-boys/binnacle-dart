
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
                width: double.infinity,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    new BoxShadow(
                      offset: new Offset(0.0, 5.0),
                      blurRadius: 5.0,
                    )
                  ],
                ),
                child: new CompassFace(),
              )
            ]
        )

    );
  }
}