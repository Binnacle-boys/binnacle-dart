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

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of(context);
    _closeEnoughValue = bloc.navigationCloseEnough;
    return Scaffold(
        floatingActionButton: _buildPopup(context),
        appBar: AppBar(title: Text("Settings")),
        drawer: AppDrawer(),
        body: Column(children: <Widget>[
          new RaisedButton(
            child: Text('Test Voice Alert'),
            onPressed: bloc.voiceAlertTest(),
          ),
          Slider(
            value: _closeEnoughValue.toDouble(),
            min: 10.0,
            max: 250.0,
            label: "Navigator: Close Enough (meters)",
            onChanged: (double newValue) {
              // bloc.setNavigationCloseEnough(value);
              setState(() {
                _closeEnoughValue = newValue.roundToDouble();
              });
              print(_closeEnoughValue);
            },
          ),
        ]));
  }
}

_buildPopup(context) {
  return FloatingActionButton(
      child: Icon(Icons.settings_bluetooth),
      backgroundColor: Colors.blue,
      onPressed: () {
        Bloc bloc = Provider.of(context);
        bloc.startScan;
        showDialog(
            context: context,
            builder: (context) => SimpleDialog(
                  title: _popupTitle(context, bloc),
                  children: [
                    Container(
                      child: _buildScanResultTiles(context, bloc),
                    )
                  ],
                ));
      });
}

Widget _buildScanResultTiles(BuildContext context, Bloc bloc) {
  return StreamBuilder(
      stream: bloc.scanResults,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('no data');
        } else if (snapshot.hasError) {
          return Text('Error');
        } else {
          var tiles = new List<Widget>();
          for (var result in snapshot.data.values) {
            if (result.device.name.length.isNotEmpty) {
              tiles.add(_scanResultTile(context, result));
            }
          }
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: tiles);
        }
      });
}

Widget _scanResultTile(context, result) {
  Bloc bloc = Provider.of(context);
  return SimpleDialogOption(
      child: Text(result.device.name.toString(), textAlign: TextAlign.left),
      onPressed: () => Navigator.pop(context, bloc.connect(result.device)));
}

Widget _popupTitle(BuildContext context, Bloc bloc) {
  return StreamBuilder(
      stream: bloc.isScanning,
      builder: (context, snapshot) {
        print("FROM SNAPSHOT " + snapshot.data.toString());
        if (snapshot.hasData) {
          return Column(
              children: (snapshot.data)
                  ? <Widget>[
                      Text("Scanning....", style: TextStyle(fontSize: 24.0)),
                      LinearProgressIndicator()
                    ]
                  : <Widget>[
                      Text(
                        "Select device",
                        style: TextStyle(fontSize: 24.0),
                      )
                    ]);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          print("Displaying no data yet");
          return Text('No data yet');
        }
      });
}

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(result.device.name),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildTitle(context),
      // leading: Text(result.rssi.toString()),
      trailing: RaisedButton(
        child: Text('CONNECT'),
        color: Colors.black,
        textColor: Colors.white,
        onPressed: (result.advertisementData.connectable) ? onTap : null,
      ),
    );
  }
}
