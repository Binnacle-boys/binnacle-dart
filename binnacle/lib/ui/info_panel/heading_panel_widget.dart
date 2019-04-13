import 'package:flutter/material.dart';
import '../../providers/app_provider.dart';
import './../global_theme.dart';

Widget windHeadingLabel(BuildContext context) {
  final bloc = Provider.of(context);
  final theme = GlobalTheme().get();
  return StreamBuilder(
      stream: bloc.wind,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
              alignment: Alignment.center,
              child: Text(degreeToCardinalString(snapshot.data.deg.floor()),
                  style: theme.textTheme.body2));
        } else if (snapshot.hasError) {
          print(
              "Error in heading_panel.dart -> windHeadingLabel, stream has error");
          return Text("Error", style: theme.textTheme.body2);
        } else {
          return Text("--", style: theme.textTheme.body2);
        }
      });
}

Widget boatHeadingLabel(BuildContext context) {
  final bloc = Provider.of(context);
  final theme = GlobalTheme().get();
  return StreamBuilder(
      stream: bloc.compass,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new Container(
              alignment: Alignment.center,
              child: Text(
                  degreeToCardinalString((snapshot.data.direction.floor())),
                  style: theme.textTheme.body2));
        } else if (snapshot.hasError) {
          print(
              "Error in heading_panel.dart -> boadHeadingLabel, stream has error");
          return Text("Error", style: theme.textTheme.body2);
        } else {
          return Text("--", style: theme.textTheme.body2);
        }
      });
}

String degreeToCardinalString(int heading) {
  // Given a degree, this func returns cardinal arc it's in e.g. 180 => 'S'
  List l = [
    'N',
    'NNE',
    'NE',
    'ENE',
    'E',
    'ESE',
    'SE',
    'SSE',
    'S',
    'SSW',
    'SW',
    'WSW',
    'W',
    'WNW',
    'NW',
    'NNW'
  ];
  int index = (((heading + 11.25) % 360) / 22.5).floor().abs();
  return l[index].toString();
}
