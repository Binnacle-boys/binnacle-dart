import '../../bloc.dart';
import 'package:flutter/material.dart';
import '../../models/wind_model.dart';

Widget weatherLabel(BuildContext context, Bloc bloc) {
  return StreamBuilder(
      stream: bloc.wind,
      builder: (context, AsyncSnapshot<WindModel> snapshot) {
        if (snapshot.hasData) {
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
                          child: Text("Wind",
                              style: Theme.of(context).textTheme.body1),
                        )),
                    Expanded(
                        flex: 5,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(snapshot.data.speed.toString(),
                                  style: Theme.of(context).textTheme.headline),
                              Container(
                                  height: 50,
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "Kt",
                                    textAlign: TextAlign.center,
                                  )),
                            ])),
                  ]));
        } else if (snapshot.hasError) {
          print(
              "Error in weather_panel.dart -> weatherLabel, stream has error");
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
  int index = ((heading + 11.5) / 22.5).floor().abs();

  return l[index].toString(); //+ " " + heading.toString() + '˚';
}
