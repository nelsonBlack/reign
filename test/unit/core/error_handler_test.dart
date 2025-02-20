import 'package:flutter_test/flutter_test.dart';
import 'package:reign/core/controller.dart';
import 'package:reign/core/error_handler.dart';
import 'package:reign/core/store.dart';

class TestErrorController extends ReignController<dynamic> with ErrorHandler {
  TestErrorController() : super(null, register: false);
}

void main() {
  group('ErrorHandler', () {
    setUp(() => ControllerStore.instance.reset());
    tearDown(() => ControllerStore.instance.reset());

    test('clearError resets error state', () {
      final controller = TestErrorController();
      ControllerStore.instance.save(controller);

      controller.error = 'test';
      controller.clearError();
      expect(controller.hasError, false);
    });

    test('handleAsync captures errors', () async {
      final controller = TestErrorController();

      await expectLater(
        controller.handleAsync(() => Future.error(Exception('test'))),
        throwsA(isA<Exception>()),
      );

      expect(controller.lastError, isA<Exception>());
      expect(controller.hasError, true);
    });

    test('handleAsync clears previous errors', () async {
      final controller = TestErrorController();
      controller.error = 'old';
      await controller.handleAsync(() => Future.value(1));
      expect(controller.hasError, false);
    });
  });
}
