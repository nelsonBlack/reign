import 'package:flutter_test/flutter_test.dart';

import '../../src/test_utils.dart';

void main() {
  group('Lifecycle Tests', () {
    test('Controller lifecycle callbacks', () {
      final controller = CounterController();
      expect(controller.isInitialized, isFalse);

      controller.init();
      expect(controller.isInitialized, isTrue);

      controller.dispose();
      expect(controller.isDisposed, isTrue);
    });
  });
}
