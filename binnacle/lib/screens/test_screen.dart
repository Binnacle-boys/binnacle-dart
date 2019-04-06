import 'package:flutter/material.dart';
import '../bloc.dart';
import '../providers/app_provider.dart';
import '../models/weather_model.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    bloc.fetchWeather();

    

   return Scaffold(
     backgroundColor: Colors.grey,
     appBar: AppBar(
       backgroundColor: Colors.blueGrey,
       title: Text("Test Screen")
     ),
     body: Column( children: <Widget>[positionLabel(bloc), weatherLabel(bloc)],)
   );
  }
}
Widget positionLabel(Bloc bloc) {
  return StreamBuilder(
    stream: bloc.position,
    builder: (context, snapshot ) {
      if (snapshot.hasData) {
        return Text('**POSISTION** Snapshot has data');
      } else if (snapshot.hasError) {
        return Text('**POSISTION** Hmmm... something went wrong');
      } else {
        return Text('**POSISTION** No data yet');
      }
    }
  );
}

Widget weatherLabel(Bloc bloc) {
  return StreamBuilder(
    stream: bloc.weather,
    builder: (context,AsyncSnapshot<WeatherModel> snapshot ) {
      if (snapshot.hasData) {
        return Text(snapshot.data.wind.speed.toString());
      } else if (snapshot.hasError) {
        return Text('**WEATHER** Hmmm... something went wrong');
      } else {
        return Text('**WEATHER** No data yet');
      }
    });
}