import 'package:flutter_test/flutter_test.dart';
import 'package:reign/core/controller.dart';
import 'package:reign/core/exceptions.dart';
import 'package:flutter/foundation.dart';

class TestController extends ReignController {}

void main() {
  group('ReignController Tests', () {
    test('ReignController implements ValueListenable', () {
      final controller = TestController();
      expect(controller, isA<ValueListenable<void>>());
    });
  });
}
