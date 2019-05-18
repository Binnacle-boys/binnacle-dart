import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sos/screens/home_screen.dart';

import 'providers/app_provider.dart';
import './ui/global_theme.dart';

const int minFingersNeedForSwipe = 3;

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
            home: ScreenWidget()  //BinnacleScreen(),
            ));
  }
}
