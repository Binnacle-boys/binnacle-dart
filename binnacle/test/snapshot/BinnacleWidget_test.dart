import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sos/ui/BinnacleUI.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets("Testing binnacle ui widget to see if it points north",
      (WidgetTester tester) async {
    // Don't test on Travis
    if (Platform.isLinux || Platform.isMacOS) {
      return;
    }
    //Setting up portrait style app
    tester.binding.renderView.configuration =
        new TestViewConfiguration(size: Size(1080, 2160));

    //Pumping similar app widget with compass UI
    await tester.pumpWidget(MaterialApp(
        title: 'Binnacle',
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new BinnacleUI(direction: 0.0),
              ],
            ),
          ),
        )));

    // Don't want this to run on travis
    await expectLater(find.byType(BinnacleUI),
        matchesGoldenFile('golden/goldenNorthCompass.png'),
        skip: Platform.isLinux);
  });
}
