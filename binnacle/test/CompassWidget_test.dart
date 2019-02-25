import 'package:flutter_test/flutter_test.dart';
import 'package:sos/ui/CompassUI.dart';
import 'package:flutter/material.dart';
import 'DiskAssetBundle.dart';

void main() {
  testWidgets("Testing compass ui widget to see if it points north", 
    (WidgetTester tester) async {
      //await tester.pumpWidget(new CompassUI(direction: 0.0));
      final assetBundle = await tester.runAsync(
        () => DiskAssetBundle.loadGlob(['navigation/*.png']),
      );
      await tester.pumpWidget(
        MaterialApp(
              title: 'Binnacle',
              home: CompassUI(direction: 0.0)
            )
        
      );
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('golden/goldenNorthCompass.png'));
    }
  );
}