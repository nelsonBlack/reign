import 'package:flutter/material.dart';
import 'package:reign/core/controller.dart';
import 'package:reign/core/store.dart';
import 'package:reign/widgets/provider.dart';

class MockController extends ReignController<dynamic> {
  MockController({super.register}) : super(null);

  @override
  void update() => super.update();

  // Add value implementation
}

class PlaceholderController extends ReignController<dynamic> {
  PlaceholderController({super.register}) : super(null);
}

class CounterController extends ReignController<int> {
  CounterController({super.register}) : super(0);

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
