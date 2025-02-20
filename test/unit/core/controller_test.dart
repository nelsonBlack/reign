import 'package:flutter_test/flutter_test.dart';
import 'package:reign/core/controller.dart';
import 'package:reign/core/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:reign/core/store.dart';

class TestController extends ReignController<int> {
  TestController() : super(0, register: false);

  bool _loading = false;
  bool get isLoading => _loading;

  Future<void> simulateAsync() async {
    _loading = true;
    update();
    await Future.delayed(Duration.zero);
    _loading = false;
    update();
  }
}

void main() {
  group('ReignController Tests', () {
    setUp(() {
      ControllerStore.instance.reset(); // Clear store before each test
    });

    tearDown(() {
      ControllerStore.instance.reset(); // Cleanup after each test
    });

    test('ReignController implements ValueListenable', () {
      final controller = TestController();
      expect(controller, isA<ValueListenable<int>>());
    });

    test('update triggers listeners', () {
      final controller = TestController();
      bool called = false;
      controller.addListener(() => called = true);
      controller.update();
      expect(called, true);
    });

    test('async update triggers state changes', () async {
      final controller = TestController();
      bool loading = false;
      controller.addListener(() => loading = controller.isLoading);

      await controller.simulateAsync();
      expect(loading, false);
    });

    test('Controller registration', () {
      final controller = TestController();
      ControllerStore.instance.save(controller);

      expect(
          ControllerStore.instance.use<TestController>(), equals(controller));
    });

    test('Controller lifecycle transitions', () async {
      final controller = TestController();

      expect(controller.isInitialized, false);
      controller.init();
      expect(controller.isInitialized, true);

      controller.markReady();
      expect(controller.isReady, true);

      controller.dispose();
      expect(controller.isDisposed, true);
    });
  });
}
