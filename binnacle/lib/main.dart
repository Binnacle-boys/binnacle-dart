import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sos/ui/list_angle_widget.dart';
import 'providers/app_provider.dart';
import 'ui/info_panel.dart';
import 'ui/compass/BinnacleBase.dart';
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
    return Provider(
        child: MaterialApp(
            title: 'Binnacle Demo',
            theme: new GlobalTheme().get(),

            home: Scaffold(
                drawer: AppDrawer(),
                body: Center(
                    child: Container(
                        child: Column(children: <Widget>[
              Expanded(
                  flex: 6,
                  child: new Stack(children: <Widget>[
                    Binnacle(),
                    ListUI(),
                  ])),
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.grey[900],
                  padding: EdgeInsets.all(10),
                  child: InfoPanel(),
                ),
              )
            ]))))));
  }
}
