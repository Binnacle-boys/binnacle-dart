import 'package:flutter/material.dart';
import 'package:sos/ui/boom_widget.dart';
import 'package:sos/ui/compass/binnacle_base.dart';
import 'package:sos/ui/global_theme.dart';
import 'package:sos/ui/info_panel.dart';
import 'package:sos/ui/list_angle_widget.dart';
import '../ui/app_drawer.dart';




class BinnacleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData _theme = new GlobalTheme().toThemeData();

   return  Scaffold(
                drawer: AppDrawer(),
                body: Center(
                    child: Container(
                        child: Column(children: <Widget>[
                  Expanded(
                      flex: 6,
                      child: new Stack(children: <Widget>[
                        Binnacle(),
                        ListAngleUI(),
                        BoomUI(),
                      ])),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: _theme.bottomAppBarColor,
                      padding: EdgeInsets.all(1),
                      child: InfoPanel(),
                    ),
                  )
                ])))
            );
}}



 