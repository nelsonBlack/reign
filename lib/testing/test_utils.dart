import 'package:flutter/material.dart';
import 'package:reign/core/controller.dart';
import 'package:reign/widgets/provider.dart';

class MockController extends ReignController<dynamic> {
  MockController() : super(null);
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
        create: () =>
            controller is MockController ? MockController() : controller,
        child: current,
      );
    }
    return current;
  }
}
