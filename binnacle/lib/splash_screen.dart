import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sos/main.dart';
import 'package:sos/providers/app_provider.dart';
import 'package:sos/ui/global_theme.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    //loadData();
  }

  void waitForBloc() async {
    Observable o = Provider.of(context).position.any((x) => x != null).asObservable();
    var first = await o.first;
    onDoneLoading();
    return;
  }

  Future<Timer> waitForGif() async {
    return new Timer(Duration(seconds: 3), waitForBloc);
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
    // onDoneLoading();
  }

  onDoneLoading() async {
    await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    waitForGif();
    return Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(children: <Widget>[
          Expanded(
              flex: 8,
              child: Container(
                  child: Container(
                height: 200,
                width: 200,
                // alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/compass.gif')),
                ),
              ))),
          Expanded(
              flex: 2,
              child: Text(
                "Created by The Binnacle Boys",
                style: new TextStyle(fontSize: 12, color: Colors.blue[300]),
              ))
        ]));
  }
}
