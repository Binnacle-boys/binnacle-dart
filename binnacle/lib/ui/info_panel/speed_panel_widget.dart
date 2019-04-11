import '../../bloc.dart';
import 'package:flutter/material.dart';
import '../../models/position_model.dart';

Widget speedLabel(BuildContext context, Bloc bloc) {
  return StreamBuilder(
      stream: bloc.position,
      builder: (context, AsyncSnapshot<PositionModel> snapshot) {
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
                          child: Text("Boat Velocity",
                              style: Theme.of(context).textTheme.body1),
                        )),
                    Expanded(
                        flex: 5,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(snapshot.data.speed.toStringAsPrecision(2),
                                  style: Theme.of(context).textTheme.headline),
                              Container(
                                height: 50,
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "Kt",
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ]))
                  ]));
        } else {
          return Text('**WEATHER** Hmmm... something went wrong');
        }
      });
}
