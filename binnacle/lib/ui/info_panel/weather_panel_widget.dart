import '../../bloc.dart';
import 'package:flutter/material.dart';
import '../../models/wind_model.dart';
import '../../providers/app_provider.dart';
import './../global_theme.dart';

Widget weatherLabel(BuildContext context) {
  final bloc = Provider.of(context);
  final theme = GlobalTheme().get();
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
                          child: Text("Wind", style: theme.textTheme.body1),
                        )),
                    Expanded(
                        flex: 5,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(snapshot.data.speed.toString(),
                                  style: theme.textTheme.headline),
                              Container(
                                  height: 50,
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "kt",
                                    textAlign: TextAlign.center,
                                  )),
                            ])),
                  ]));
        } else if (snapshot.hasError) {
          print(
              "Error in weather_panel.dart -> weatherLabel, stream has error");
          return Text("Error", style: theme.textTheme.headline);
        } else {
          return Text("-.-", style: theme.textTheme.headline);
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
