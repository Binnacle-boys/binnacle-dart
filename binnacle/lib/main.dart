import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'WindRequest.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  double _direction;
  NumberFormat headingFormat = new NumberFormat("##0.0#", "en_US");
  Geolocator geolocator;
  LocationOptions locationOptions;
  Position _location;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    print('Initializing the state');
    super.initState();
    initSensorsApi();
  }

  //Setting up hardware sensor apis
  void initSensorsApi() {
    initCompassApi();
    initLocationApi();
  }

  //Setting up compass api listener
  void initCompassApi() {
    FlutterCompass.events.listen((double direction) {
      setState(() {
        _direction = direction;
      });
    });
    geolocator.getPositionStream(locationOptions).listen(
      (Position position) {
        print('Position heard');
        print(_location == null ? 'Unknown' : _location.latitude.toString() + ', ' + _location.longitude.toString());
        setState(() {
          print('Position! heard');
          _location = position;
        });
    });
    geolocator.getPositionStream(locationOptions).listen(
      (Position position) {
        print('Position heard');
        print(_location == null ? 'Unknown' : _location.latitude.toString() + ', ' + _location.longitude.toString());
        setState(() {
          print('Position! heard');
          _location = position;
        });
    });


  }

  //Setting up location api listener
  void initLocationApi() {
    geolocator = Geolocator();
    int distanceFilt = 10;
    locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: distanceFilt);
    geolocator.getPositionStream(locationOptions).listen(
      (Position position) {
        print('Position heard');
        print(_location == null ? 'Unknown' : _location.latitude.toString() + ', ' + _location.longitude.toString());
        setState(() {
          print('Position! heard');
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            Text(
              _direction == null ? 'Direction unknown' : 'Heading: ' + headingFormat.format(_direction),
              style: Theme.of(context).textTheme.display1,
            ),
            Text(
              _location == null ? 'Latitude unknown' : 'Latitude: ' + headingFormat.format(_location.latitude),
              style: Theme.of(context).textTheme.display1,
            ),
            Text(
              _location == null ? 'Longitude unknown' : 'Longitude: ' + headingFormat.format(_location.longitude),
              style: Theme.of(context).textTheme.display1,
            ),
            FutureBuilder<WindRequest>(
                future: fetchWind(_location.latitude, _location.longitude),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done && snapshot.data != null){
                    return Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                snapshot.data.wind.heading == null ? 'Wind Heading unknown' : 'Wind Heading: ' + headingFormat.format(snapshot.data.wind.heading),
                                style: Theme.of(context).textTheme.display1,
                              ),
                              Text(
                                snapshot.data.wind.speed == null ? 'Wind Speed unknown' : 'Wind Speed: ' + headingFormat.format(snapshot.data.wind.speed),
                                style: Theme.of(context).textTheme.display1,
                              ),
                            ]
                        )
                    );
                  }
                  else if(snapshot.hasError){
                    return Container(
                      child: Text(snapshot.error.toString())
                    );
                  }
                  else{
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator()
                        ],
                      )
                    );
                  }
                }
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
