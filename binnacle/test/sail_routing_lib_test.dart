import 'package:flutter_test/flutter_test.dart';
import 'package:sail_routing/sail_routing.dart';

void main() {
  test('hello world', () {
    SailRoute sailRoute = SailRoute();
    expect(sailRoute.hello(), "Hello from the sail_routing lib");
  });
}
