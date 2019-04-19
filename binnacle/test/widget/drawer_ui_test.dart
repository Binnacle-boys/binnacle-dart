import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sos/providers/app_provider.dart';
import 'package:sos/ui/app_drawer.dart';
import 'dart:collection';

void main() {
  DemoProvider p;
  LinkedHashMap service_options;
  List just_options;
  setUp() async {
    p = await new DemoProvider();
    service_options = new LinkedHashMap();
    service_options["compass"] = ["flutter compass", "mock compass"];
    // service_options["wind"] = ["no data yet"];
    service_options["position"] = ["No data yet"];
    just_options = ["flutter compass", "mock compass", "No data yet"];

  }

  
  testWidgets(
      "Drawer UI: Builds drawer menu and verifies that a drawer was made for each provider. (as defined in drawer_ui_test.dart -> service_options)",
      (WidgetTester tester) async {
    await setUp();
    await tester.pumpWidget(p);
    await tester.pump();

    for (String serv in service_options.keys) {
      expect(find.text(serv), findsOneWidget);
      await tester.pump();
    }
  });

  testWidgets(
      "Drawer UI: Expands and collapses each drawer, checks for service options (as defined in drawer_ui_test.dart -> service_options)",
      (WidgetTester tester) async {
    await setUp();

    await tester.pumpWidget(p);
    
    await tester.pump(new Duration(seconds: 3));
    await tester.pump();
    for (String serv in service_options.keys) {
      await tester.tap(find.byKey(Key(serv)));
      await tester.pump();
    }

    for(var unique_option in just_options.toSet()){
      expect(find.text(unique_option), findsOneWidget);
    }
  });
}

class DemoProvider extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
        child: MaterialApp(
      title: 'Binnacle Demo',
      home: TestScreen(),
    ));
  }
}

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AppDrawer());
  }
}
