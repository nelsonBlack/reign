import 'package:flutter_test/flutter_test.dart';
import 'package:reign/core/controller.dart';
import 'package:reign/core/store.dart';

import '../../src/test_utils.dart';

// Create controllers without auto-registration for testing
class TestUserService extends ReignController {
  TestUserService() : super(register: false);
}

class TestAuthController extends ReignController {
  late final TestUserService userService;

  TestAuthController() : super(register: false);

  @override
  void init() {
    userService = dependOn<TestUserService>();
    super.init();
  }
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
      store.register(userService);
      store.register(authController);

      // Initialize controller to trigger dependency resolution
      authController.init();

      expect(authController.userService, equals(userService));
    });
  });
}
