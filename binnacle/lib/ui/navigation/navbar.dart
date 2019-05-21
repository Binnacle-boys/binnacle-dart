import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sos/bloc.dart';

import 'package:sos/enums.dart';
import 'package:sos/providers/app_provider.dart';
import 'package:sos/providers/navigation_provider.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key key}) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  double opacity = 1;

  @override
  Widget build(BuildContext context) {
    final Bloc bloc = Provider.of(context);

    return StreamBuilder(
        stream: bloc.navigationEventBus,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot?.data is NavigationEvent) {
            print('Building a navbar from the event');
            return Opacity(opacity: opacity, child: _Navbar(snapshot?.data));
          } else {
            return Container();
          }
        });
  }

  Widget _Navbar(NavigationEvent event) {
    print('_Navbar $event');
    print(event.eventType);
    switch (event.eventType) {
      case NavigationEventType.start:
      case NavigationEventType.tackNow:
      print('Creating a special event!');
        if (opacity != 1) {
          setState(() => opacity = 1);
        }
        
        Future.delayed(
            const Duration(seconds: 5), () => setState(() => opacity = 0));

        return Container(
            alignment: Alignment.topLeft,
            height: 100,
            padding: EdgeInsets.only(top: 20),
            color: Colors.grey[800],
            child: _NavbarMessage(event.eventType));
      default:
        print('Could not create a navbar');
        return Container();
    }
  }

  Widget _NavbarMessage(NavigationEventType event) {
    print('Making a navbar message');
    switch (event) {
      case NavigationEventType.start:
        return Container(
          child: Center(
              child: Text('Starting course!',
                  style: TextStyle(color: Colors.white))),
        );
      default:
        print('Could not find this $event');
        return Text('$event');
    }
  }
}
