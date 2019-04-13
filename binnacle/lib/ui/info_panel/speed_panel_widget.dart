import 'package:flutter/material.dart';
import '../../models/position_model.dart';
import '../../providers/app_provider.dart';
import './../global_theme.dart';

Widget boatSpeedLabel(BuildContext context) {
  final theme = GlobalTheme().get();
  return new Container(
      alignment: Alignment.center,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Text("Boat Velocity", style: theme.textTheme.body1),
                )),
            Expanded(
                flex: 5,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      boatSpeedStreamBuilder(context),
                      Container(
                        height: 50,
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "kt",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ]))
          ]));
}

Widget boatSpeedStreamBuilder(BuildContext context) {
  final theme = GlobalTheme().get();
  final bloc = Provider.of(context);
  return StreamBuilder(
      stream: bloc.position,
      builder: (context, AsyncSnapshot<PositionModel> snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data.speed.toStringAsFixed(2),
              style: theme.textTheme.headline);
        } else if (snapshot.hasError) {
          print(
              "Error in weather_panel.dart -> weatherLabel, stream has error");
          return Text("Error", style: theme.textTheme.headline);
        } else {
          return Text("-.-", style: theme.textTheme.headline);
        }
      });
}
