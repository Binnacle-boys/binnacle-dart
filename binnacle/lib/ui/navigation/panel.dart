import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sos/bloc.dart';

import 'package:sos/enums.dart';
import 'package:sos/providers/app_provider.dart';
import 'package:sos/ui/global_theme.dart';

class NavigationPanel extends StatelessWidget {
  NavigationPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = GlobalTheme();
    final bloc = Provider.of(context);

    return StreamBuilder(
        stream: bloc.navigationEventBus,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.data.eventType.toString());
          if (snapshot.hasError) {
            return SlidingUpPanel(
              panel: null,
            );
          } else if (!snapshot.hasData) {
            return SlidingUpPanel(panel: null);
          } else {
            return Dismissible(
              key: Key('navigation'),
              onDismissed: (dismissal) {
                print(dismissal);
              },
              child: SlidingUpPanel(
                color: GlobalTheme().toThemeData().primaryColor,
                backdropEnabled: true,
                backdropTapClosesPanel: true,
                slideDirection: SlideDirection.DOWN,
                panelSnapping: true,
                minHeight: (snapshot.data.eventType ==
                        NavigationEventType.awaitingInit)
                    ? 0
                    : 100,
                maxHeight: 200,
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                panel: _panel(snapshot.data.eventType)));
          }
        });
  }

  Widget _panel(NavigationEventType event) {
    switch (event) {
      case NavigationEventType.start:
        return NavigationPanelBase(message: _startCourseMessage());
      case NavigationEventType.tackNow:
        return NavigationPanelBase(message: _tackNowMessage());
      default:
        print('No event panel for $event');
    }
  }

  Widget _nullPanel(context, bloc) {
    return SizedBox.shrink();
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
