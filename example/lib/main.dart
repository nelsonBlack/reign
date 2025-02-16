import 'package:flutter/material.dart';
import 'package:reign/reign.dart';
import 'pages/home_screen.dart';
import 'controllers/theme_controller.dart';
import 'controllers/counter_controller.dart';
import 'controllers/todo_controller.dart';
import 'controllers/user_controller.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ReignMultiProvider(
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
