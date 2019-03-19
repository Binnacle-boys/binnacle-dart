import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import './CoordInputRoute.dart'; //ignore: unused_import
import './model/DataModel.dart';
import './BinnacleWidget.dart';
import './ui/deck/DeckWidget.dart'; //ignore: unused_import

import './model/bluetooth/BluetoothManager.dart'; //ignore: unused_import

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Binnacle',
      
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Binnacle'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DataModel _model;
  NumberFormat headingFormat = new NumberFormat("##0.0#", "en_US");

  @override
  void initState() {
    print('Initializing the state');
    super.initState();

    /// Portrait orientation lock
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // TODO: Abstract this to a builder
    bool phoneModel = true;
    if (phoneModel) {
      _model = new DataModel(SensorType.phone);
    } else {
      throw new Exception("Other data models not implemented");
    }

    // BluetoothManager().printDevices();

    // var btManager = BluetoothManager();
    // btManager.printDevices();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          elevation: 0.0,
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_location),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CoordInputRoute())
              );
            }),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
              // Column is also layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    DeckWidget(),
                    // CompassWidget(directionStream: _model.currentBoat.compassHeading?.stream)
                    Padding(
                      child: BinnacleWidget(model: _model),
                      padding: EdgeInsets.fromLTRB(10.0, 80.0, 10.0, 0),
                    )
                  ],
                ),
              ]),
        ));
  }
}
