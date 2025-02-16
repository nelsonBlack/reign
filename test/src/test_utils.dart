import 'package:flutter/material.dart';
import 'package:reign/core/controller.dart';
import 'package:reign/core/store.dart';
import 'package:reign/widgets/provider.dart';

class MockController extends ReignController {
  MockController({super.register});

  @override
  void update() => super.update();

  // Add value implementation
  @override
  void get value {}
}

class PlaceholderController extends ReignController {
  PlaceholderController({super.register});
}

class CounterController extends ReignController {
  CounterController({super.register});

  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    update();
  }
}

Widget testWidget({
  required Widget child,
  List<ReignController> controllers = const [],
}) {
  return MaterialApp(
    home: Scaffold(
      body: MultiProvider(
        controllers: controllers,
        child: child,
      ),
    ),
  );
}

class MultiProvider extends StatelessWidget {
  final List<ReignController> controllers;
  final Widget child;

  const MultiProvider({
    super.key,
    required this.controllers,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget current = child;
    for (final controller in controllers.reversed) {
      current = ControllerProvider(
        create: () => controller,
        child: current,
      );
    }
    return current;
  }
}
