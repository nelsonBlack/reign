import 'package:example/controllers/user_controller.dart';
import 'package:example/widgets/theme_switcher.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reign Demo'),
        //  actions: <Widget>[const ThemeSwitcher()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReignBuilder<UserController>(
              builder: (context, userCtrl) => Text(
                userCtrl.user?.name ?? 'Guest User',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CounterScreen())),
              child: const Text('Local Counter'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TodoScreen())),
              child: const Text('Global Todos'),
            ),
          ],
        ),
      ),
    );
  }
}
