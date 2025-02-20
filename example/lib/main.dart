import 'package:flutter/material.dart';
import 'package:reign/reign.dart';
import 'package:reign/widgets/reign_builder.dart';
import 'pages/home_screen.dart';
import 'controllers/theme_controller.dart';
import 'controllers/counter_controller.dart';
import 'controllers/todo_controller.dart';
import 'controllers/user_controller.dart';

void main() {
  runApp(
    ReignMultiProvider(
      controllers: [
        ThemeController(),
        TodoController(initialValue: []),
        UserController(initialValue: null),
      ],
      child: const AppRoot(),
    ),
  );
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return ControllerConsumer<ThemeController>(
      builder: (context, themeCtrl) => MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeCtrl.value,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
