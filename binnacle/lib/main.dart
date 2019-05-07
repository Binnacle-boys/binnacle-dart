import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sos/ui/compass/binnacle_base.dart';

import 'package:sos/ui/list_angle_widget.dart';
import 'providers/app_provider.dart';
import 'ui/info_panel.dart';
import './ui/global_theme.dart';
import './ui/app_drawer.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeData _theme = new GlobalTheme().get();
    return Provider(
        child: MaterialApp(
            title: 'Binnacle Demo',
            theme: _theme,
            home: Scaffold(
                drawer: AppDrawer(),
                body: Center(
                    child: Container(
                        child: Column(children: <Widget>[
                  Expanded(
                      flex: 6,
                      child: new Stack(children: <Widget>[
                        Binnacle(),
                        ListAngleUI(),
                      ])),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: _theme.secondaryHeaderColor,
                      padding: EdgeInsets.all(10),
                      child: InfoPanel(),
                    ),
                  )
                ])))
            )
        ));
  }
}
