import 'package:flutter_test/flutter_test.dart';
import 'package:reign/reign.dart';
import 'src/test_utils.dart';
import 'package:reign/core/exceptions.dart';
import 'package:flutter/material.dart';

import 'unit/core/store_test.dart';

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

      store.save(controller);
      expect(store.use<MockController>(), equals(controller));

      store.remove(MockController);
      expect(() => store.use<MockController>(),
          throwsA(isA<ControllerNotFoundError>()));
    });

    testWidgets('ControllerProvider integration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ControllerProvider<TestController>(
            create: () => TestController(),
            child: Builder(
              builder: (context) {
                final controller =
                    ControllerProvider.of<TestController>(context);
                return Container();
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsOneWidget);
    });
  });
}
