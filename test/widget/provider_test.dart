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
      final controller = PlaceholderController();
      ControllerStore.instance.save(controller);

      await tester.pumpWidget(
        MaterialApp(
          home: ControllerProvider<PlaceholderController>(
            create: () => controller,
            child: const Placeholder(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Placeholder), findsOneWidget);
    });

    testWidgets('ControllerConsumer reacts to updates', (tester) async {
      final controller = CounterController();
      ControllerStore.instance.save(controller);

      await tester.pumpWidget(
        MaterialApp(
          home: ControllerProvider(
            create: () => controller,
            child: ControllerConsumer<CounterController>(
              builder: (context, controller) =>
                  Text('Count: ${controller.count}'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('Count: 0'), findsOneWidget);

      // Get controller and update state
      controller.increment();

      // Wait for widget to rebuild
      await tester.pump();

      // Verify updated state
      expect(find.text('Count: 1'), findsOneWidget);
    });
  });
}
