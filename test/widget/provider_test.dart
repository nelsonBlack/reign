import 'package:flutter_test/flutter_test.dart';
import 'package:reign/reign.dart';
import 'package:reign/widgets/provider.dart';
import '../src/test_utils.dart';
import 'package:flutter/material.dart';

void main() {
  setUp(() {
    ControllerStore.debugMode = true; // Enable debug logging
    ControllerStore.instance.reset();
    // Add any required mocks
  });

  tearDown(() {
    ControllerStore.instance.reset();
  });

  group('Widget Tests', () {
    testWidgets('ControllerProvider builds child widget', (tester) async {
      await tester.pumpWidget(testWidget(
        controllers: [PlaceholderController()],
        child: const Placeholder(),
      ));

      expect(find.byType(Placeholder), findsOneWidget);
    });

    testWidgets('ControllerConsumer reacts to updates', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ControllerProvider(
            create: () => CounterController(),
            child: ControllerConsumer<CounterController>(
              builder: (context, controller) =>
                  Text('Count: ${controller.count}'),
            ),
          ),
        ),
      );

      // Verify initial state
      expect(find.text('Count: 0'), findsOneWidget);

      // Get controller and update state
      final controller = ControllerStore.instance.get<CounterController>();
      controller.increment();

      // Wait for widget to rebuild
      await tester.pump();
      await tester.pumpAndSettle();

      // Verify updated state
      expect(find.text('Count: 1'), findsOneWidget);
    });
  });
}
