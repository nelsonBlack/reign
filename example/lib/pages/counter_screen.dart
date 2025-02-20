import 'package:flutter/material.dart';
import 'package:reign/reign.dart';
import '../controllers/counter_controller.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ReignBuilder<CounterController>(
      create: () => CounterController(initialValue: 0),
      builder: (context, controller) => Scaffold(
        appBar: AppBar(title: const Text('Local Counter')),
        body: Center(
          child: Text('Count: ${controller.value}',
              style: Theme.of(context).textTheme.headlineMedium),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.increment,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
