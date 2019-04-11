import '../../bloc.dart';
import 'package:flutter/material.dart';
import '../../models/compass_model.dart';

Widget windHeadingLabel(BuildContext context, Bloc bloc) {
  return StreamBuilder(
      stream: bloc.wind,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
              alignment: Alignment.center,
              child: Text(degreeToCardinalString(snapshot.data.deg.floor()),
                  style: Theme.of(context).textTheme.body2));
        } else if (snapshot.hasError) {
          print(
              "Error in heading_panel.dart -> windHeadingLabel, stream has error");
          return Text(' ');
        } else {
          return Text(' ');
        }
      });
}

Widget boatHeadingLabel(BuildContext context, Bloc bloc) {
  return StreamBuilder(
      stream: bloc.compass,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new Container(
              alignment: Alignment.center,
              child: Text(
                  degreeToCardinalString((snapshot.data.direction.floor())),
                  style: Theme.of(context).textTheme.body2));
        } else if (snapshot.hasError) {
          print(
              "Error in heading_panel.dart -> boadHeadingLabel, stream has error");
          return Text(' ');
        } else {
          return Text(' ');
        }
      });
}

String degreeToCardinalString(int heading) {
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
  int index = ((heading + 11.25) / 22.5).floor().abs();
  return l[index].toString(); // + " " + heading.toString() + '˚';
}
