import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sos/screens/binnacle_screen.dart';
import 'package:sos/screens/map_screen.dart';
import 'screens/test_screen.dart';

import 'providers/app_provider.dart';
import './ui/global_theme.dart';

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
            title: 'Binnacle Demo',
            theme: _theme,
            home: PageView(
              children: <Widget>[BinnacleScreen(), MapScreen(), TestScreen()],
              pageSnapping: true,
            )
            //BinnacleScreen(),
            ));
  }
}
