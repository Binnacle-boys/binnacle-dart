import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/position_model.dart';
import './../global_theme.dart';

class boatSpeedStreamBuilder extends StatelessWidget {
  final positionStream;
  const boatSpeedStreamBuilder({Key key, this.positionStream})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = GlobalTheme().get();
    return StreamBuilder(
        stream: positionStream,
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
}

Widget boatSpeedLabel({BehaviorSubject positionStream}) {
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
                      boatSpeedStreamBuilder(positionStream: positionStream),
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
