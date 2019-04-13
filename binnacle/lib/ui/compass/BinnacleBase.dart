import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sos/providers/app_provider.dart';
import 'package:sos/ui/BinnacleHeadingUI.dart';
import 'package:sos/ui/compass/CompassDialPainter.dart';
import 'CompassFace.dart';
import 'dart:math';

import 'package:sos/model/Wind.dart';
import 'package:sos/bloc.dart';
import 'package:sos/BinnacleHeadingWidget.dart';

class BinnacleState extends State<Binnacle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: BinnacleBase(context),
    );
  }
}

class Binnacle extends StatefulWidget {
  @override
  BinnacleState createState() => new BinnacleState();
}

class BinnacleBase extends StatelessWidget {
  BinnacleBase(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return new Container(
        child: new Stack(children: <Widget>[
      new Container(
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
        ),
      ),
      new Container(
        alignment: Alignment.center,
        child: BinnacleCompass(bloc),
      )
    ]));
  }
}

Widget BinnacleCompass(Bloc bloc) {
  return StreamBuilder(
      stream: bloc.compass,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // TODO this +27 is a total hacky way to fix an offset we are getting
          return new Transform.rotate(
              angle: ((snapshot.data.direction ?? 0) * (pi / 180) * -1),
              child: CompassFace());
        } else if (snapshot.hasError) {
          print(
              "From BinnacleBase -> BinnacleCompass: Error in compass stream");
          return Text(' ');
        } else {
          return CircularProgressIndicator(
            backgroundColor: Colors.green,
          );
        }
      });
}
