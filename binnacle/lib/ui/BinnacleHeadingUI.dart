import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sos/models/wind_model.dart';
import 'package:sos/providers/app_provider.dart';
import 'ArrowPainter.dart';

class BinnacleHeadingUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return StreamBuilder(
        stream: bloc.wind,
        builder: (context, AsyncSnapshot<WindModel> snapshot) {
          if (snapshot.hasData) {
            return new Transform.rotate(
                angle: (pi / 180) * snapshot.data.deg,
                child: new Align(
                  alignment: Alignment.topCenter,
                  child: CustomPaint(painter: ArrowPainter(percentChange: 0.5)),
                ));
          } else if (snapshot.hasError) {
            print("Error in BinnacleHeading, stream has error");
            return Text("");
          } else {
            return new Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator());
            //return Text("Bad wind data", style: theme.textTheme.headline);
          }
        });
  }
}
