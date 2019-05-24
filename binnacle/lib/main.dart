import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sos/bloc.dart';
import 'package:sos/screens/binnacle_screen.dart';
import 'package:sos/splash_screen.dart';
import 'screens/test_screen.dart';

import 'providers/app_provider.dart';
import './ui/global_theme.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sos/enums.dart';
import 'package:sos/screens/home_screen.dart';

import 'providers/app_provider.dart';
import './ui/global_theme.dart';

const int minFingersNeedForSwipe = 3;

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(Provider(child: MaterialApp(home: SplashScreen())));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeData _theme = new GlobalTheme().toThemeData();

    return MaterialApp(
        debugShowCheckedModeBanner: true, //TODO change to false before release
        title: 'Binnacle Demo',
        theme: _theme,
        home: NavigationPanel(children: [BinnacleScreen(), TestScreen()]));
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
          // print(snapshot.data.eventType.toString());
          if (snapshot.hasError) {
            return SlidingUpPanel(
              panel: null,
            );
          } else if (!snapshot.hasData) {
            return SlidingUpPanel(panel: null);
          } else {
            return SlidingUpPanel(
                color: GlobalTheme().toThemeData().primaryColor,
                backdropEnabled: true,
                backdropTapClosesPanel: true,
                slideDirection: SlideDirection.DOWN,
                panelSnapping: true,
                minHeight: (snapshot.data.eventType == NavigationEventType.awaitingInit) ? 0 : 75,
                maxHeight: 300,
                borderRadius: BorderRadius.all(Radius.circular(25.0)),

                //@Will put the panels here
                panel: NavigationPanelBase(message: _tackNowMessage()),
                body: PageView(
                  children: this.children, //<Widget>[BinnacleScreen(), TestScreen()],
                  pageSnapping: true,
                ));
          }
        });
  }

  Widget _coordInputPanel(context, bloc) {
    return Center(child: Text('Coord Input panel'));
  }

  Widget _nullPanel(context, bloc) {
    return SizedBox.shrink();
  }

  Widget _tackNowMessage() {
    return Row(
      children: <Widget>[
        Transform.rotate(
          child: Icon(
            Icons.call_missed_outgoing,
            size: 80,
            color: Colors.red,
          ),
          angle: -90,
        ),
        Text("Tack Now.", style: TextStyle(fontSize: 48))
      ],
    );
  }

  Widget _nullMessage() {
    return Text('');
  }
}

class NavigationPanelBase extends StatelessWidget {
  final Bloc bloc;
  final Widget message;

  NavigationPanelBase({@required this.bloc, @required this.message});
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(
      children: <Widget>[
        _hideButton(bloc),
        _cancelButton(bloc),
        _navigationMessage(bloc, message),
      ],
    ));
  }

  Widget _navigationMessage(bloc, message) {
    var theme = GlobalTheme();
    return Positioned(
      top: 150,
      left: 45,
      child: message,
    );
  }

  Widget _cancelButton(Bloc bloc) {
    return Positioned(
        top: 45,
        left: 0,
        child: RawMaterialButton(
          shape: CircleBorder(),
          fillColor: Colors.red[300],
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onPressed: () => {}, //TODO Hook this up to the bloc
        ));
  }

  Widget _hideButton(Bloc bloc) {
    var theme = GlobalTheme();
    return Positioned(
        top: 45,
        right: 0,
        child: RawMaterialButton(
          fillColor: Colors.grey[600],
          shape: CircleBorder(),
          child: Icon(
            Icons.close,
            color: Colors.deepOrangeAccent,
          ),
          onPressed: () => {}, //TODO Hook this up to the bloc
        ));
  }
}
