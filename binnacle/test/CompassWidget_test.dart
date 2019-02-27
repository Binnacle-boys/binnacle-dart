import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sos/ui/CompassUI.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets("Testing compass ui widget to see if it points north", 
    (WidgetTester tester) async {
      //await tester.pumpWidget(new CompassUI(direction: 0.0));
      // final assetBundle = await tester.runAsync(
      //   () => DiskAssetBundle.loadGlob(['navigation/*.png']),
      // );
      tester.binding.renderView.configuration = new TestViewConfiguration(size: Size(1080, 2160));
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
      await expectLater(find.byType(CompassUI), 
        matchesGoldenFile('golden/goldenNorthCompass.png'),
        skip: !Platform.isLinux);
    }
  );
}