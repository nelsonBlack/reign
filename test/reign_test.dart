import 'package:flutter_test/flutter_test.dart';
import 'package:reign/reign.dart';
import 'src/test_utils.dart';
import 'package:reign/core/exceptions.dart';
import 'package:flutter/material.dart';

void main() {
  late ControllerStore store;

  setUp(() {
    store = ControllerStore.instance;
    store.reset();
  });

  tearDown(() {
    store.reset();
  });

  group('State Management Tests', () {
    test('Controller registration and access', () {
      final controller = MockController(register: false);

      store.register(controller);
      expect(store.get<MockController>(), equals(controller));

      store.unregister(controller);
      expect(() => store.get<MockController>(),
          throwsA(isA<ControllerNotFoundError>()));
    });

    testWidgets('ControllerProvider integration', (tester) async {
      await tester.pumpWidget(testWidget(
        controllers: [PlaceholderController(register: false)],
        child: Container(),
      ));

      expect(find.byType(Container), findsOneWidget);
    });
  });
}
