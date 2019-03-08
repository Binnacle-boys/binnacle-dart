import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import './model/DataModel.dart';
import './ui/deck/DeckWidget.dart';
import './CompassWidget.dart';


// import './SpeedWidget.dart';
// import './CompassWidget.dart';
// import 'WindRequest.dart';
// import 'ListAngleWidget.dart';
// import './model/bluetooth/BluetoothManager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Binnacle Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Binnacle Demo (Main)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DataModel _model;
  Position _location;
  NumberFormat headingFormat = new NumberFormat("##0.0#", "en_US");

  @override
  void initState() {
    print('Initializing the state');
    super.initState();
    // Portrait orientation lock
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // TODO: Abstract this to a factory (down the line might be a builder)
    bool phoneModel = true;
    if (phoneModel) {
      _model = new DataModel(SensorType.phone);
    } else {
      throw new Exception("Other data models not implemented");
    }

    _model.currentBoat.positionStream.listen(
      (Position position) {
        setState(() {
          print('PhoneModel position heard');
          _location = position;
        });
      });

    // BluetoothManager().printDevices();
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(),
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
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Stack(
              children: <Widget>[
                DeckWidget(),
                Positioned(
                  top: 100,
                  child: CompassWidget()
                  )
              ]
            ,)


            // SpeedWidget(positionStream: _model.currentBoat.positionStream),
            // Text(
            //   _location == null ? 'Latitude unknown' : 'Latitude: ' + headingFormat.format(_location.latitude),
            //   style: Theme.of(context).textTheme.display1,
            // ),
            // ListAngleWidget(listAngleStream: _model.currentBoat.listAngle.stream.asBroadcastStream()),
            // Text(
            //   _location == null ? 'Longitude unknown' : 'Longitude: ' + headingFormat.format(_location.longitude),
            //   style: Theme.of(context).textTheme.display1,
            // ),
            // CompassWidget(directionStream: _model.currentBoat.compassHeading?.stream),
            // FutureBuilder<WindRequest>(
            //     future: fetchWind(_location),
            //     builder: (context, snapshot) {
            //       if(snapshot.connectionState == ConnectionState.done && snapshot.data != null){
            //         return Center(
            //             child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: <Widget>[
            //                   Text(
            //                     snapshot.data.wind.heading == null ? 'Wind Heading unknown' : 'Wind Heading: ' + snapshot.data.wind.heading,
            //                     style: Theme.of(context).textTheme.display1,
            //                   ),
            //                   Text(
            //                     snapshot.data.wind.speed == null ? 'Wind Speed unknown' : 'Wind Speed: ' + snapshot.data.wind.speed,
            //                     style: Theme.of(context).textTheme.display1,
            //                   ),
            //                 ]
            //             )
            //         );
            //       }
            //       else if(snapshot.hasError){
            //         return Container(
            //           child: Text(snapshot.error.toString())
            //         );
            //       }
            //       else{
            //         return Center(
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: <Widget>[
            //               CircularProgressIndicator()
            //             ],
            //           )
            //         );
            //       }
            //     }
            // )
          ],
        ),
      
    ));
  }
}
