import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sos/bloc.dart';
import 'package:sos/screens/binnacle_screen.dart';
import 'package:sos/screens/map_screen.dart';
import 'package:sos/screens/splash_screen.dart';
import 'enums.dart';
// import 'screens/test_screen.dart';

import 'package:sos/screens/home_screen.dart';
import 'package:sos/providers/app_provider.dart';
import 'package:sos/ui/global_theme.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(Provider(
      child: MaterialApp(
          debugShowCheckedModeBanner: true, //TODO change to false before release

          title: 'Binnacle Demo',
          theme: GlobalTheme().toThemeData(),
          home: SplashScreen())));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ScreenWidget());
  }
}
