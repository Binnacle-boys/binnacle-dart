import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sos/ui/global_theme.dart';
import '../../models/wind_model.dart';

Widget weatherLabel({BehaviorSubject windStream}) {
  final theme = GlobalTheme();
  return new Container(
      alignment: Alignment.center,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text("Wind", style: theme.textTheme.body1),
            )),
        Expanded(
            flex: 5,
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              new weatherStreamBuilder(windStream: windStream),
              Container(
                  height: 50,
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "kt",
                    textAlign: TextAlign.center,
                  )),
            ])),
      ]));
}

class weatherStreamBuilder extends StatelessWidget {
  final windStream;
  const weatherStreamBuilder({Key key, this.windStream}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = GlobalTheme();

    return StreamBuilder(
        stream: windStream.stream,
        builder: (context, AsyncSnapshot<WindModel> snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.speed.toStringAsFixed(2), style: theme.textTheme.headline);
          } else if (snapshot.hasError) {
            print("Error in weather_panel.dart -> weatherLabel, stream has error");
            return Text("Error", style: theme.textTheme.headline);
          } else {
            return Text("-.-", style: theme.textTheme.headline);
          }
        });
  }
}
