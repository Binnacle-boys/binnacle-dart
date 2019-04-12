import 'package:flutter/material.dart';
import 'providers/app_provider.dart';
import 'ui/info_panel.dart';
import 'ui/compass/BinnacleBase.dart';
import './ui/global_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
        child: MaterialApp(
            title: 'Binnacle Demo',
            theme: new GlobalTheme().get(),
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
    final bloc = Provider.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: BinnacleBase(context),
      //Text('Binnacle will go here', style: GlobalTheme().get().textTheme.body1),
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
