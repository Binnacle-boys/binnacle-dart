import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sos/ui/CompassUI.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets("Testing compass ui widget to see if it points north", 
    (WidgetTester tester) async {
      if (Platform.isLinux) {
        return;
      }
      //Setting up portrait style app
      tester.binding.renderView.configuration = new TestViewConfiguration(size: Size(1080, 2160));
      
      //Pumping similar app widget with compass UI
      await tester.pumpWidget(
        MaterialApp(
              title: 'Binnacle',
              home: Scaffold(
                body: Center(
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new CompassUI(direction: 0.0),
                    ],
                  ),
              ),
              )
            )
        
      );

      // Don't want this to run on travis
      await expectLater(find.byType(CompassUI), 
        matchesGoldenFile('golden/goldenNorthCompass.png'),
        skip: Platform.isLinux);
    }
  );
}