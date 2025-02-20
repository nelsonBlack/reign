import 'package:flutter/material.dart';
import 'package:reign/reign.dart';
import '../controllers/theme_controller.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return ControllerConsumer<ThemeController>(
      builder: (context, controller) => IconButton(
        icon: Icon(controller.value == ThemeMode.dark
            ? Icons.light_mode
            : Icons.dark_mode),
        onPressed: controller.toggleTheme,
      ),
    );
  }
}
