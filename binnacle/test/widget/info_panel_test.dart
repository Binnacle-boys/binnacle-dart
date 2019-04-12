import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sos/providers/app_provider.dart';
import 'package:sos/ui/global_theme.dart';
import 'package:sos/ui/info_panel.dart';

void main() {
  testWidgets(
      "__Info_panel UI: Proper initializing ui elements with empty streams",
      (WidgetTester tester) async {
    await tester.pumpWidget(new Provider(
        child: MaterialApp(
            title: 'Binnacle Demo',
            theme: new GlobalTheme().get(),
            home: InfoPanel())));
    expect(find.text("-.-"), findsNWidgets(2));
    expect(find.text("--"), findsNWidgets(2));
  });
}
