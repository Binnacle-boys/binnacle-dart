import 'package:flutter/material.dart';
import 'providers/app_provider.dart';
import 'ui/info_panel.dart';

// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';

// import './CoordInputRoute.dart'; //ignore: unused_import
// import './model/DataModel.dart';
import './BinnacleWidget.dart';

// import './ui/deck/DeckWidget.dart'; //ignore: unused_import

// import './model/bluetooth/BluetoothManager.dart'; //ignore: unused_import

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
        child: MaterialApp(
            title: 'Binnacle Demo',
            theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.yellow[100],
              backgroundColor: Colors.grey[850],
              bottomAppBarColor: Colors.grey[900],
              textTheme: new TextTheme(
                body1: new TextStyle(
                    color: Colors.amber[100],
                    fontFamily: "Arial",
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                body2: new TextStyle(
                    color: Colors.amber[100],
                    fontFamily: "Arial",
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
                headline: new TextStyle(
                    color: Colors.amber[100],
                    fontFamily: "Arial",
                    fontSize: 65,
                    fontWeight: FontWeight.bold),
                title: new TextStyle(
                    color: Colors.amber[100],
                    fontFamily: "Arial",
                    fontSize: 120,
                    fontWeight: FontWeight.bold),
              ),
              primarySwatch: Colors.blueGrey,
            ),
            home: Scaffold(
                body: Center(
                    child: Container(
                        child: Column(children: <Widget>[
              Expanded(
                flex: 7,
                child: Binnacle(),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.grey[900],
                  padding: EdgeInsets.all(10),
                  child: InfoPanelState(context),
                ),
              )
            ]))))));
  }
}

class BinnacleState extends State<Binnacle> {
  // #enddocregion RWS-class-only
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20), child: BinnacleWidget(context)
        //   child: Text(
        // 'Binnacle will go here',
        // style: TextStyle(
        //   fontWeight: FontWeight.bold,

        );
  }
}

class Binnacle extends StatefulWidget {
  @override
  BinnacleState createState() => new BinnacleState();
}

Widget InfoPanelState(BuildContext context) {
  // #enddocregion RWS-class-only

  return Container(
    child: Center(
      child: InfoPanel(),
    ),
  );
}
