import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sos/bloc.dart';
import 'package:sos/screens/binnacle_screen.dart';
import 'screens/test_screen.dart';

import 'providers/app_provider.dart';
import './ui/global_theme.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sos/enums.dart';


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
            home: NavigationPanel(children:[BinnacleScreen(), TestScreen()])
             
        ));
  }
}


class NavigationPanel extends StatelessWidget {

  final List<Widget> children;

  NavigationPanel({@required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = GlobalTheme();
    final bloc = Provider.of(context);
    
    return StreamBuilder(
      stream: bloc.navigationEventBus,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print(snapshot.data.eventType.toString());
        if(snapshot.hasError) {
          return SlidingUpPanel(panel: null,);
        } else if (!snapshot.hasData) {
          return SlidingUpPanel(panel:null);
        } else {
          return SlidingUpPanel(
            color: GlobalTheme().toThemeData().primaryColor,      
            backdropEnabled: true,
            backdropTapClosesPanel: true,
            slideDirection: SlideDirection.DOWN,
            panelSnapping: true,
            minHeight:75,
            maxHeight: 300,
            borderRadius: BorderRadius.all(Radius.circular(25.0)),

            //@Will put the panels here
            panel: Center(
              child: _coordInputPanel(context, bloc)
            ),
            body:  PageView(
              children: this.children,//<Widget>[BinnacleScreen(), TestScreen()],
              pageSnapping: true,
            )
        ); 
      }

    });
  }

  Widget _coordInputPanel(context, bloc) {
    return Text('Coord Input panel');

  }
  Widget _nullPanel(context, bloc) {
    return SizedBox.shrink();
  }


}








