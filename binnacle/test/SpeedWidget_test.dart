import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sos/SpeedWidget.dart';

void main() {
  testWidgets("Speed widget when no position stream given", 
    (WidgetTester tester) async {
      await tester.pumpWidget(SpeedWidget(positionStream: null));
      expect(find.text("Loading speed"), findsOneWidget);
    }
  );
}