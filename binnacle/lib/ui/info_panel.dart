import 'package:flutter/material.dart';

import './global_theme.dart';
import './info_panel/weather_panel_widget.dart';
import './info_panel/heading_panel_widget.dart';
import './info_panel/speed_panel_widget.dart';

class InfoPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = GlobalTheme().get();

    return Scaffold(
        backgroundColor: theme.bottomAppBarColor,
        body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  flex: 5,
                  child: Column(children: <Widget>[
                    Expanded(flex: 5, child: boatSpeedLabel(context)),
                    Expanded(
                      flex: 5,
                      child: boatHeadingLabel(context),
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
                          child: weatherLabel(context),
                        ),
                        Expanded(
                          flex: 5,
                          child: windHeadingLabel(context),
                        ),
                      ]))),
            ]));
  }
}
