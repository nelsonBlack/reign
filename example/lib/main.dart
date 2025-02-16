import 'package:flutter/material.dart';
import 'package:reign/reign.dart';
import 'package:reign/testing/test_utils.dart';

void main() {
  runApp(const MainApp());
}

// Controllers
class CounterController extends ReignController {
  int _count = 0;
  int currentCount() => _count;

  void increment() {
    _count++;
    update();
  }
}

class ThemeController extends ReignController {
  ThemeMode _theme = ThemeMode.light;

  ThemeMode currentTheme() => _theme;

  void toggleTheme() {
    _theme = _theme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    update();
  }
}

class TodoController extends ReignController {
  final List<String> _todos = [];

  List<String> todos() => List.unmodifiable(_todos);

  void addTodo(String text) {
    _todos.add(text);
    update();
  }
}

class UserController extends ReignController {
  String? _user;
  bool _loading = false;

  // Add init lifecycle override
  @override
  void onInit() {
    super.onInit();
    fetchUser(); // Auto-fetch when controller initializes
  }

  String? currentUser() => _user;
  bool isLoading() => _loading;

  Future<void> fetchUser() async {
    _loading = true;
    update();

    await Future.delayed(const Duration(seconds: 1));
    _user = 'Reign User';
    _loading = false;
    update();
  }
}

// Main App
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      controllers: [
        ThemeController(),
        CounterController(),
        TodoController(),
        UserController(),
      ],
      child: ControllerConsumer<ThemeController>(
        builder: (context, themeCtrl) => MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeCtrl.currentTheme(),
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

// Home Screen with Navigation
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reign Demos')),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Counter Demo'),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CounterDemo())),
            ),
            ListTile(
              title: const Text('Theme Switcher'),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ThemeDemo())),
            ),
            ListTile(
              title: const Text('Todo List'),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const TodoDemo())),
            ),
            ListTile(
              title: const Text('User Profile'),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const UserDemo())),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Select a demo from the drawer'),
      ),
    );
  }
}

// Demo Screens
class CounterDemo extends StatelessWidget {
  const CounterDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter Demo')),
      body: Center(
        child: ControllerConsumer<CounterController>(
          builder: (context, controller) => Text(
            'Count: ${controller.currentCount()}',
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ),
      floatingActionButton: ControllerConsumer<CounterController>(
        builder: (context, controller) => FloatingActionButton(
          onPressed: controller.increment,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class ThemeDemo extends StatelessWidget {
  const ThemeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = ControllerProvider.of<ThemeController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Switcher')),
      body: Center(
        child: Text(
          'Current Theme: ${themeCtrl.currentTheme().name.toUpperCase()}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: themeCtrl.toggleTheme,
        child: const Icon(Icons.color_lens),
      ),
    );
  }
}

class TodoDemo extends StatelessWidget {
  const TodoDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final todoCtrl = ControllerProvider.of<TodoController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: ControllerConsumer<TodoController>(
        builder: (context, controller) => ListView.builder(
          itemCount: controller.todos().length,
          itemBuilder: (ctx, i) => ListTile(
            title: Text(controller.todos()[i]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) {
            final textController = TextEditingController();
            return AlertDialog(
              title: const Text('Add Todo'),
              content: TextField(controller: textController),
              actions: [
                TextButton(
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      todoCtrl.addTodo(textController.text);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                )
              ],
            );
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class UserDemo extends StatelessWidget {
  const UserDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final userCtrl = ControllerProvider.of<UserController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: ControllerConsumer<UserController>(
        builder: (context, controller) => Center(
          child: controller.isLoading()
              ? const CircularProgressIndicator()
              : controller.currentUser() != null
                  ? Text(
                      'Welcome ${controller.currentUser()}!',
                      style: Theme.of(context).textTheme.headlineMedium,
                    )
                  : const Text('No user data'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: userCtrl.fetchUser,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
