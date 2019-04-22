import 'package:flutter/material.dart';
import 'package:sos/providers/app_provider.dart';

import './global_theme.dart';
import './info_panel/weather_panel_widget.dart';
import './info_panel/heading_panel_widget.dart';
import './info_panel/speed_panel_widget.dart';

class InfoPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = GlobalTheme().get();
    final bloc = Provider.of(context);

    return Scaffold(
        backgroundColor: theme.bottomAppBarColor,
        body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  flex: 5,
                  child: Column(children: <Widget>[
                    Expanded(
                        flex: 5,
                        child: boatSpeedLabel(positionStream: bloc.position)),
                    Expanded(
                      flex: 5,
                      child: boatHeadingLabel(compassStream: bloc.compass),
                    ),
                  ])),
              Expanded(
                  flex: 5,
                  child: Container(
                      decoration: new BoxDecoration(
                          border: new Border(
                              left: new BorderSide(
                                  color: theme.backgroundColor))),
                      padding: EdgeInsets.only(right: 1),
                      child: Column(children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: weatherLabel(windStream: bloc.wind),
                        ),
                        Expanded(
                          flex: 5,
                          child: windHeadingLabel(
                            windStream: bloc.wind,
                          ),
                        ),
                      ]))),
            ]));
  }
}
