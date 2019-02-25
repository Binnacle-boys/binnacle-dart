import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import './model/DataModel.dart';
import './SpeedWidget.dart';
import 'WindRequest.dart';
import './DeckWidget.dart';

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
      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomPaint(
            painter: DeckWidget(),
            child: Container(
              height: 700,
            ),
          ),
        ),
      // Center(

        // child: Column(

          // mainAxisAlignment: MainAxisAlignment.center,
          // children: <Widget>[
 
            // SpeedWidget(positionStream: _model.currentBoat.positionStream),
            // Text(
            //   _location == null ? 'Latitude unknown' : 'Latitude: ' + headingFormat.format(_location.latitude),
            //   style: Theme.of(context).textTheme.display1,
            // ),
            // Text(
            //   _location == null ? 'Longitude unknown' : 'Longitude: ' + headingFormat.format(_location.longitude),
            //   style: Theme.of(context).textTheme.display1,
            // ),
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
          // ],
        // ),
      // ),
    );
  }
}
