import 'package:flutter_test/flutter_test.dart';
import 'package:sail_routing/sail_routing.dart';

void main() {
  test('sail routing algorithm test method', () {
    SailRoute algorithm = new SailRoute();

    expect(algorithm.hello(), "Hello from the sail_routing lib");
  });
}
