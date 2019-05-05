import 'package:flutter/material.dart';
import 'package:sos/models/compass_model.dart';
import 'package:sos/models/wind_model.dart';
import './../global_theme.dart';

class windHeadingLabel extends StatelessWidget {
  final windStream;
  const windHeadingLabel({Key key, this.windStream}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = GlobalTheme();

    return StreamBuilder(
        stream: windStream.stream,
        builder: (context, AsyncSnapshot<WindModel> snapshot) {
          if (snapshot.hasData) {
            return Text(degreeToCardinalString(snapshot.data.deg), style: theme.textTheme.headline);
          } else if (snapshot.hasError) {
            print("Error in weather_panel.dart -> weatherLabel, stream has error");
            return Text("Error", style: theme.textTheme.headline);
          } else {
            return Text("--", style: theme.textTheme.headline);
          }
        });
  }
}

class boatHeadingLabel extends StatelessWidget {
  final compassStream;
  const boatHeadingLabel({Key key, this.compassStream}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = GlobalTheme();

    return StreamBuilder(
        stream: compassStream.stream,
        builder: (context, AsyncSnapshot<CompassModel> snapshot) {
          if (snapshot.hasData) {
            return Text(degreeToCardinalString(snapshot.data.direction), style: theme.textTheme.headline);
          } else if (snapshot.hasError) {
            print("Error in weather_panel.dart -> weatherLabel, stream has error");
            return Text("Error", style: theme.textTheme.headline);
          } else {
            return Text("--", style: theme.textTheme.headline);
          }
        });
  }
}

String degreeToCardinalString(double heading) {
  // Given a degree, this func returns cardinal arc it's in e.g. 180 => 'S'
  List l = ['N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'];
  int index = (((heading + 11.25) % 360) / 22.5).floor().abs();
  return l[index].toString();
}
