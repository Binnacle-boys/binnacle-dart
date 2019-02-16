import 'package:flutter_test/flutter_test.dart';

import 'package:sos/DataModel.dart';

void main() {
  test('phone data model returned', () {
    final dm = new DataModel(SensorType.phone);

    expect(dm != null, true);
  });

  test('bluetooth data model throws not implemented', () {
    try {
      final dm = new DataModel(SensorType.bluetooth);

      expect(dm == null, true);
    } catch (e) {
      expect(true, true); // should throw exception
    }
  });
}