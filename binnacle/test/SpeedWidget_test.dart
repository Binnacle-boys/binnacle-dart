import 'package:flutter_test/flutter_test.dart';
import 'package:sos/SpeedWidget.dart';



void main() {
  testWidgets("Speed widget when no position stream given", 
    (WidgetTester tester) async {
      await tester.pumpWidget(SpeedWidget(positionStream: null));
      expect(find.text("Loading speed"), findsOneWidget);
    }
  );
  testWidgets("Testing position stream", 
    (WidgetTester tester) async {
      expect(true, true);
      /// TODO: Do pull request on the geolocator plug-in to add a 
      /// public constructor for simpler testing. Not able to mock 
      /// position at the moment.
    }
  );
}


