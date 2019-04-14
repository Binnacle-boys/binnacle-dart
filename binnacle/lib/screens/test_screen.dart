import 'package:flutter/material.dart';
import 'package:sos/models/list_angle_model.dart';
import '../bloc.dart';
import '../providers/app_provider.dart';
import '../models/wind_model.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
            backgroundColor: Colors.blueGrey, title: Text("Test Screen")),
        body: Column(children: <Widget>[
          listAngleLabel(bloc),
          positionLabel(bloc),
          weatherLabel(bloc),
          compassLabel(bloc),
          swapCompassButton(bloc)
        ]));
  }
}

Widget swapCompassButton(Bloc bloc) {
  return RaisedButton(
    onPressed: () {
      print("pushed button");
      bloc.changeCompassSource();
    },
    child: Text("Click to change compass source"),
    color: Colors.deepOrange,
  );
}

Widget positionLabel(Bloc bloc) {
  return StreamBuilder(
      stream: bloc.position,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(children: <Widget>[
            Text("Lat: " + snapshot.data.lat.toString()),
            Text("Lon: " + snapshot.data.lon.toString()),
            Text("Speed: " + snapshot.data.speed.toString()),
          ]);
        } else if (snapshot.hasError) {
          return Text('**POSISTION** Hmmm... something went wrong');
        } else {
          return Text('**POSISTION** No data yet');
        }
      });
}

Widget compassLabel(Bloc bloc) {
  return StreamBuilder(
      stream: bloc.compass,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data.direction.toString());
        } else if (snapshot.hasError) {
          return Text('**COMPASS** Hmmm... something went wrong');
        } else {
          return Text('**COMPASS** No data yet');
        }
      });
}

Widget weatherLabel(Bloc bloc) {
  return StreamBuilder(
      stream: bloc.wind,
      builder: (context, AsyncSnapshot<WindModel> snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data.speed.toString());
        } else if (snapshot.hasError) {
          return Text('**WEATHER** Hmmm... something went wrong');
        } else {
          return Text('**WEATHER** No data yet');
        }
      });
}

Widget listAngleLabel(Bloc bloc) {
  return StreamBuilder(
      stream: bloc.listAngle,
      builder: (context, AsyncSnapshot<ListAngleModel> snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data.angle.toStringAsFixed(2),
            style: TextStyle(color: Colors.red, fontSize: 50),
          );
        } else if (snapshot.hasError) {
          return Text('**WEATHER** Hmmm... something went wrong');
        } else {
          return Text('**WEATHER** No data yet');
        }
      });
}
