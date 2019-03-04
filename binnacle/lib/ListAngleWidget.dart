import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sos/utils/Math.dart';
import 'dart:ui' as dartui;

class ListAngleWidget extends StatefulWidget {
  ListAngleWidget({Key key, this.listAngleStream}) : super(key: key);

  final Stream<double> listAngleStream;

  @override
  _ListAngleWidgetState createState() => _ListAngleWidgetState();
}

class _ListAngleWidgetState extends State<ListAngleWidget> {
  
  /// In case streamsubscription needs to be managed
  StreamSubscription<double> _listAngleSub;
  StreamSubscription<double> get doubleSub => _listAngleSub;
  
  double _listAngle;
  NumberFormat format;

  @override
  void initState() {
    super.initState();
    // Set listen to updateListAngle call
    // Returns null if listAngleStream is null
    _listAngleSub = widget.listAngleStream?.listen(updateListAngle);
    // Setting up a standard format for speed
    // TODO: Use a static class for these formats in future
    format = new NumberFormat("##0.0#", "en_US");
  }

  /// Assigned to the listener to update the state of this widget
  void updateListAngle(double listAngle) {
    setState(() {
      _listAngle = listAngle;
    });
  }
  String listText(double radians) {
    return "List Angle: " + format.format(radiansToDegrees(radians)) + " deg";
  }

  @override
  Widget build(BuildContext context) {
    return Text(listText(_listAngle), textDirection: dartui.TextDirection.ltr);
  }
}

