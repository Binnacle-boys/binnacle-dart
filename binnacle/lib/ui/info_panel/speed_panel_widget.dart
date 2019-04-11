import 'package:flutter/material.dart';
import '../../models/position_model.dart';
import '../../providers/app_provider.dart';
import './../global_theme.dart';

Widget speedLabel(BuildContext context) {
  final bloc = Provider.of(context);
  final theme = GlobalTheme().get();
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
                              style: theme.textTheme.body1),
                        )),
                    Expanded(
                        flex: 5,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(snapshot.data.speed.toStringAsPrecision(2),
                                  style: theme.textTheme.headline),
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
        } else {
          return Text("-.-", style: theme.textTheme.headline);
        }
      });
}
