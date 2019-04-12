import 'package:flutter/material.dart';
import 'package:sos/models/wind_model.dart';
import 'package:sos/providers/app_provider.dart';
import 'package:sos/ui/global_theme.dart';

import 'package:sos/utils/Math.dart';
import 'ArrowPainter.dart';

class BinnacleHeadingUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    final theme = GlobalTheme().get();
    return StreamBuilder(
        stream: bloc.wind,
        builder: (context, AsyncSnapshot<WindModel> snapshot) {
          if (snapshot.hasData) {
            return new Transform.rotate(
                angle: degreesToRadians(snapshot.data.deg),
                child: new Align(
                    alignment: Alignment.topCenter,
                    child: CustomPaint(
                        painter: ArrowPainter(
                            color: theme.accentColor, percentChange: 0.5))));
          } else if (snapshot.hasError) {
            print("Error in BinnacleHeading, stream has error");
            return Text("Bad wind data", style: theme.textTheme.headline);
          } else {
            return Text("Bad wind data", style: theme.textTheme.headline);
          }
        });
  }
}
