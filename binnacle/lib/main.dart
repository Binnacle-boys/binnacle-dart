import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sos/screens/binnacle_screen.dart';
import 'screens/test_screen.dart';

import 'providers/app_provider.dart';
import './ui/global_theme.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeData _theme = new GlobalTheme().toThemeData();
    return Provider(
        child: MaterialApp(
            debugShowCheckedModeBanner: true, //TODO change to false before release
            title: 'Binnacle Demo',
            theme: _theme,
            home: SlidingUpPanel(
              color: _theme.primaryColor,      
              backdropEnabled: true,
              backdropTapClosesPanel: true,
              slideDirection: SlideDirection.UP,
              panelSnapping: true,
              minHeight:75,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),

              panel: Center(
                child: Text("This is the sliding Widget"),
              ),
              body:  PageView(
                children: <Widget>[BinnacleScreen(), TestScreen()],
                pageSnapping: true,
              )
            )
             
            //BinnacleScreen(),
        ));
  }
}
