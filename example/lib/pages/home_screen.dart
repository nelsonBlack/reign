import 'package:flutter/material.dart';
import 'package:reign/reign.dart';
import '../controllers/theme_controller.dart';
import 'counter_screen.dart';
import 'todo_screen.dart';
import 'user_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = ControllerProvider.of<ThemeController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reign Demo'),
        actions: [
          IconButton(
            icon: Icon(themeCtrl.currentTheme() == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: themeCtrl.toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CounterScreen()),
              ),
              child: const Text('Counter Demo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TodoScreen()),
              ),
              child: const Text('Todo List'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserScreen()),
              ),
              child: const Text('User Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
