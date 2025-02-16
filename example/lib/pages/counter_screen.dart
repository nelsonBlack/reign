import 'package:flutter/material.dart';
import 'package:reign/reign.dart';
import '../controllers/counter_controller.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter Demo')),
      body: Center(
        child: ControllerConsumer<CounterController>(
          builder: (context, controller) => Text(
            'Count: ${controller.currentCount()}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
      floatingActionButton: ControllerConsumer<CounterController>(
        builder: (context, controller) => FloatingActionButton(
          onPressed: controller.increment,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
