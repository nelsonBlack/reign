import 'package:flutter/material.dart';
import 'package:reign/reign.dart';

class ThemeController extends ReignController {
  ThemeMode _theme = ThemeMode.light;

  ThemeMode currentTheme() => _theme;

  void toggleTheme() {
    _theme = _theme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    update();
  }
}
