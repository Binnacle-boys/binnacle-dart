import 'package:flutter/material.dart';
import 'package:sos/ui/app_drawer.dart';
import 'package:sos/bloc.dart';
import 'package:sos/providers/app_provider.dart';
import 'package:flutter_blue/flutter_blue.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  Bloc bloc;
  double _closeEnoughValue;
  double _maxOffset;

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of(context);
    _closeEnoughValue = bloc.navigationCloseEnough;
    _maxOffset = bloc.navigationMaxOffset;

    return Scaffold(
        appBar: AppBar(title: Text("Settings")),
        drawer: AppDrawer(),
        body: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.all(25),
              child: RaisedButton(
                child: Text('Test Voice Alert'),
                //  onPressed: bloc.voiceAlertTest(),
              )),
          Column(children: <Widget>[
            Text('Navigator Close Enough Value: ${_closeEnoughValue.round()} meters'),
            Slider(
              value: _closeEnoughValue,
              min: 10.0,
              max: 250.0,
              onChanged: (double newValue) {
                setState(() {
                  bloc.setNavigationCloseEnough(newValue);
                });
              },
            )
          ]),
          Column(children: <Widget>[
            Text('Navigator Max Offset: ${_maxOffset.round()} meters'),
            Slider(
              value: _maxOffset,
              min: 10.0,
              max: 500.0,
              onChanged: (value) => setState(() {
                    bloc.setNavigationMaxOffset(value);
                  }),
            )
          ]),
        ]));
  }
}
