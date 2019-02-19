import 'package:flutter_test/flutter_test.dart';
import 'package:sos/SpeedWidget.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:geolocator/geolocator.dart';


void main() {
  testWidgets("Speed widget when no position stream given", 
    (WidgetTester tester) async {
      await tester.pumpWidget(SpeedWidget(positionStream: null));
      expect(find.text("Loading speed"), findsOneWidget);
    }
  );
  testWidgets("Testing position stream", 
    (WidgetTester tester) async {
      final positionSubject = new BehaviorSubject<Position>();
      await tester.pumpWidget(SpeedWidget(positionStream: positionSubject.stream));
      positionSubject.stream.listen((Position pos) {
        print("Speed:" + pos.speed.toString());
      });
      expect(find.text("Loading speed"), findsOneWidget);
      //Making mock position of speed 0 for testing
      Position mockPosition = new Position(speed: 0.0);
      
      //Update stream
      positionSubject.add(mockPosition);

      // Waiting for the listen emission
      await tester.pump(Duration.zero);
      expect(find.text("0.0 mph"), findsOneWidget);
    }
  );
}


