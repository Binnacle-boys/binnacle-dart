import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sos/models/position_model.dart';
import 'package:sos/models/wind_model.dart';
import 'package:sos/ui/info_panel/speed_panel_widget.dart';
import 'package:sos/ui/info_panel/weather_panel_widget.dart';

void main() {
  //Testers for the speed labels (boat speed and wind speed) in the info panel of the UI

  BehaviorSubject<PositionModel> _positionStream =
      BehaviorSubject<PositionModel>();
  BehaviorSubject<WindModel> _windStream = BehaviorSubject<WindModel>();
  testWidgets(
      "__BoatSpeed UI (speeed_panel_widget.dart -> boatSpeedLabel): Proper initializing ui with empty stream",
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: boatSpeedLabel(positionStream: _positionStream)));

    expect(find.text("-.-"), findsOneWidget);
  });

  testWidgets(
      "__BoatHeading UI (heading_panel_widget.dart -> boatHeadingLabel): Proper display of speed in stream, tests 1.0 mps => 1.94kt",
      (WidgetTester tester) async {
    await _positionStream.add(PositionModel(lat: 1.0, lon: 1.0, speed: 1.0));
    await tester.pumpWidget(
        MaterialApp(home: boatSpeedLabel(positionStream: _positionStream)));
    //await compassStream.add(CompassModel(direction: 9.0));
    await tester.pump();

    for (var x in tester.allWidgets.whereType<Text>()) {
      print(x.toString() + "\n");
    }

    expect(find.text("1.94"), findsOneWidget);
    expect(find.text("kt"), findsOneWidget);
  });

  /*
    START WIND SPEED TESTS
  */
  testWidgets(
      "__WindSpeed UI (weather_panel_widget.dart -> weatherLabel): Proper initializing ui with empty stream",
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: weatherLabel(windStream: _windStream)));

    expect(find.text("-.-"), findsOneWidget);
  });

  testWidgets(
      "__BoatSpeed UI (speed_panel_widget.dart -> boatSpeedLabel): Proper display of speed in stream, tests 1.0 mps => 1.94kt",
      (WidgetTester tester) async {
    await _positionStream.add(PositionModel(lat: 1.0, lon: 1.0, speed: 1.0));
    await tester.pumpWidget(
        MaterialApp(home: boatSpeedLabel(positionStream: _positionStream)));

    await tester.pump();
    expect(find.text("1.94"), findsOneWidget);
    expect(find.text("kt"), findsOneWidget);
  });
}
