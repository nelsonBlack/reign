import 'package:flutter/material.dart';
import 'package:reign/reign.dart';

class ThemeController extends ReignController<ThemeMode> {
  final ThemeMode _theme = ThemeMode.system;

  ThemeController() : super(ThemeMode.system);

  ThemeMode currentTheme() => value;

  void toggleTheme() {
    value = value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    update();
  }
}
