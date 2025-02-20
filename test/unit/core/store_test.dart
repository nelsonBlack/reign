import 'package:flutter_test/flutter_test.dart';
import 'package:reign/core/controller.dart';
import 'package:reign/core/store.dart';
import 'package:reign/core/exceptions.dart';

import '../../src/test_utils.dart';

// Create controllers without auto-registration for testing
class TestUserService extends ReignController<void> {
  TestUserService() : super(null, register: false);
}

class TestAuthController extends ReignController<void> {
  late final TestUserService userService;

  TestAuthController() : super(null, register: false);

  @override
  void init() {
    userService = dependOn<TestUserService>();
    super.init();
  }
}

class TestController extends ReignController<void> {
  TestController() : super(null, register: false);
}

void main() {
  group('Store Tests', () {
    late ControllerStore store;

    setUp(() {
      store = ControllerStore.instance;
      store.reset();
    });

    tearDown(() {
      store.reset();
    });

    test('ReignController dependencies', () {
      final userService = TestUserService();
      final authController = TestAuthController();

      // Now we can safely register them explicitly
      store.save(userService);
      store.save(authController);

      // Initialize controller to trigger dependency resolution
      authController.init();

      expect(authController.userService, equals(userService));
    });

    test('Should retrieve registered controller', () {
      final store = ControllerStore.instance;
      final controller = TestController();

      // Explicitly register the controller first
      ControllerStore.instance.save(controller);

      final result = store.use<TestController>();
      expect(result, equals(controller));
    });

    test('Should throw when retrieving unregistered controller', () {
      final store = ControllerStore.instance;
      expect(() => store.use<TestController>(),
          throwsA(isA<ControllerNotFoundError>()));
    });
  });
}
