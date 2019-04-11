import 'package:flutter/material.dart';
import '../bloc.dart';
import '../providers/app_provider.dart';
import '../models/wind_model.dart';

import './info_panel/weather_panel_widget.dart';
import './info_panel/heading_panel_widget.dart';
import './info_panel/speed_panel_widget.dart';

class InfoPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  flex: 5,
                  child: Column(children: <Widget>[
                    Expanded(flex: 5, child: speedLabel(context, bloc)),
                    Expanded(
                      flex: 5,
                      child: boatHeadingLabel(context, bloc),
                    ),
                  ])),
              Expanded(
                  flex: 5,
                  child: Container(
                      decoration: new BoxDecoration(
                          border: new Border(
                              left: new BorderSide(
                                  color: Theme.of(context).backgroundColor))),
                      padding: EdgeInsets.only(right: 1),
                      child: Column(children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: weatherLabel(context, bloc),
                        ),
                        Expanded(
                          flex: 5,
                          child: windHeadingLabel(context, bloc),
                        ),
                      ]))),
            ]));
  }
}
