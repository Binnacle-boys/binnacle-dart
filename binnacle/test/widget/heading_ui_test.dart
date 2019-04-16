import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sos/models/compass_model.dart';
import 'package:sos/models/wind_model.dart';
import 'package:sos/ui/info_panel/heading_panel_widget.dart';

void main() {
  //Testers for the heading labels in the info panel of the UI

  BehaviorSubject<CompassModel> compassStream = BehaviorSubject<CompassModel>();

  testWidgets(
      "__BoatHeading UI (heading_panel_widget.dart -> boatHeadingLabel): Proper initializing ui with empty streams",
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: boatHeadingLabel(compassStream: compassStream)));

    expect(find.text("--"), findsOneWidget);
  });

  testWidgets(
      "__BoatHeading UI (heading_panel_widget.dart -> boatHeadingLabel): Proper display of degrees in stream, tests 'N' = 1˚",
      (WidgetTester tester) async {
    await compassStream.add(CompassModel(direction: 1.0));
    await tester.pumpWidget(
        MaterialApp(home: boatHeadingLabel(compassStream: compassStream)));
    //await compassStream.add(CompassModel(direction: 9.0));
    await tester.pump();

    expect(find.text("N"), findsOneWidget);
  });

  BehaviorSubject<WindModel> _windStream = BehaviorSubject<WindModel>();

  testWidgets(
      "__WindHeading UI (heading_panel_widget.dart -> windHeadingLabel): Proper initializing ui with empty streams",
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: windHeadingLabel(windStream: _windStream)));
    expect(find.text("--"), findsOneWidget);
  });

  testWidgets(
      "__WindHeading UI (heading_panel_widget.dart -> windHeadingLabel):  Proper display of degrees in stream, tests 'N' = 1˚",
      (WidgetTester tester) async {
    await _windStream.add(WindModel(1.0, 1.0));

    await tester.pumpWidget(
        MaterialApp(home: windHeadingLabel(windStream: _windStream)));
    await tester.pump();
    expect(find.text("N"), findsOneWidget);
  });
}
