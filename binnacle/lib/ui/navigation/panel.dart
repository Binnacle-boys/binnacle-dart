import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sos/bloc.dart';

import 'package:sos/enums.dart';
import 'package:sos/providers/app_provider.dart';
import 'package:sos/providers/navigation_provider.dart';
import 'package:sos/ui/global_theme.dart';

class NavigationPanel extends StatelessWidget {
  NavigationPanel({Key key}) : super(key: key);

  Bloc bloc;

  @override
  Widget build(BuildContext context) {
    final theme = GlobalTheme();
    bloc = Provider.of(context);

    return StreamBuilder(
        stream: bloc.navigationEventBus,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError || !snapshot.hasData || snapshot.data.eventType == null) {
            return new Container();
          } else {
            return new SlidingUpPanel(
                color: GlobalTheme().toThemeData().primaryColor,
                backdropEnabled: true,
                backdropTapClosesPanel: true,
                slideDirection: SlideDirection.DOWN,
                panelSnapping: true,
                minHeight: (snapshot.data.eventType ==
                        NavigationEventType.init)
                    ? 0
                    : 100,
                maxHeight: 200,
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                panel: _panel(snapshot.data.eventType));          
          }
        });
  }

  Widget _panel(NavigationEventType event) {
    switch (event) {
      case NavigationEventType.calculatingRoute:
        return NavigationPanelBase(bloc: bloc, message: _calculatingCourseMessage());
      case NavigationEventType.start:
        return NavigationPanelBase(bloc: bloc, message: _startCourseMessage());
      case NavigationEventType.tackNow:
        return NavigationPanelBase(bloc: bloc, message: _tackNowMessage());
      default:
        print('No event panel for $event');
        return NavigationPanelBase(bloc: bloc, message: new Container());
    }
  }

  Widget _calculatingCourseMessage() {
    return Row(
      children: <Widget>[
        Icon(Icons.sync),
        Text("Calculating course", style: TextStyle(fontSize: 32))
      ],
    );
  }

  Widget _startCourseMessage() {
    return Row(
      children: <Widget>[
        Icon(Icons.directions_boat),
        Text("Starting course", style: TextStyle(fontSize: 32))
      ],
    );
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
