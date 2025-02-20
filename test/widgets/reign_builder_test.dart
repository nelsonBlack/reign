import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reign/core/controller.dart';
import 'package:reign/core/store.dart';
import 'package:reign/core/exceptions.dart';
import 'package:reign/widgets/reign_builder.dart';

class TestController extends ReignController<int> {
  int initCount = 0;
  int readyCount = 0;
  int disposeCount = 0;
  @override
  int value = 0;
  bool isReadyCalled = false;

  TestController() : super(0, register: false);

  @override
  void onInit() {
    super.onInit();
    initCount++;
  }

  @override
  void onReady() {
    super.onReady();
    readyCount++;
    isReadyCalled = true;
  }

  @override
  void onDispose() {
    super.onDispose();
    disposeCount++;
  }

  void increment() {
    value++;
    update();
  }
}

void main() {
  group('ReignBuilder', () {
    setUp(() {
      ControllerStore.instance.reset();
    });

    tearDown(() {
      ControllerStore.instance.reset();
    });

    testWidgets('creates and disposes controller when using create',
        (tester) async {
      late TestController createdController;

      await tester.pumpWidget(
        MaterialApp(
          home: ReignBuilder<TestController>(
            create: () {
              createdController = TestController();
              return createdController;
            },
            builder: (context, controller) =>
                Text('Value: ${controller.value}'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(createdController.initCount, 1);
      expect(createdController.readyCount, 1);
      expect(createdController.context, isNotNull);

      await tester.pumpWidget(Container());
      expect(createdController.disposeCount, 1);
      expect(createdController.isDisposed, true);
    });

    testWidgets('uses existing controller when provided', (tester) async {
      final existingController = TestController();
      await tester.pumpWidget(
        MaterialApp(
          home: ReignBuilder<TestController>(
            controller: existingController,
            builder: (context, controller) =>
                Text('Value: ${controller.value}'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(existingController.initCount, 1);
      expect(existingController.readyCount, 1);

      await tester.pumpWidget(Container());
      expect(existingController.disposeCount,
          0); // Should not dispose external controller
      expect(existingController.isDisposed, false);
    });

    testWidgets('rebuilds on controller update', (tester) async {
      final controller = TestController();
      await tester.pumpWidget(
        MaterialApp(
          home: ReignBuilder<TestController>(
            controller: controller,
            builder: (context, controller) =>
                Text('Value: ${controller.value}'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Value: 0'), findsOneWidget);

      controller.increment();
      await tester.pump();
      expect(find.text('Value: 1'), findsOneWidget);
    });

    testWidgets('uses saved controller', (tester) async {
      final savedController = TestController();
      ControllerStore.instance.save(savedController);

      await tester.pumpWidget(
        MaterialApp(
          home: ReignBuilder<TestController>.use(
            builder: (context, controller) =>
                Text('Value: ${controller.value}'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Value: 0'), findsOneWidget);
    });

    testWidgets('applies theme when provided', (tester) async {
      final testTheme = ThemeData(
        colorScheme: ColorScheme.light().copyWith(
          primary: const Color(0xFFFF0000),
        ),
        textTheme: TextTheme(bodyLarge: TextStyle()),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ReignBuilder<TestController>(
            create: () => TestController(),
            theme: testTheme,
            builder: (context, controller) {
              return Builder(
                builder: (innerContext) {
                  return Text('Test',
                      style: Theme.of(innerContext)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              color:
                                  Theme.of(innerContext).colorScheme.primary));
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.color, const Color(0xFFFF0000));
    });

    testWidgets('throws error when no controller available for global',
        (tester) async {
      await expectLater(
        () => ControllerStore.instance.use<TestController>(),
        throwsA(isA<ControllerNotFoundError>()),
      );
    });

    testWidgets('ReignBuilder.use propagates controller not found error',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ReignBuilder<TestController>.use(
            builder: (context, controller) => Container(),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isA<ControllerNotFoundError>());
    });

    testWidgets('initializes and disposes controller', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ReignBuilder(
            create: () => TestController(),
            builder: (context, controller) => Container(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final controller = ControllerStore.instance.use<TestController>();
      expect(controller.isInitialized, true);

      await tester.pumpWidget(Container());
      expect(controller.isDisposed, true);
    });

    testWidgets('calls onReady after layout', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ReignBuilder(
            create: () => TestController(),
            builder: (context, controller) => Container(),
          ),
        ),
      );
      await tester.pumpAndSettle(); // Wait for post-frame callback

      final controller = ControllerStore.instance.use<TestController>();
      expect(controller.isReady, true);
      expect(controller.isReadyCalled, true);
    });
  });
}
