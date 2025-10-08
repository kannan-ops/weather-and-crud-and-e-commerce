import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get currentTheme =>
      _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme([bool? value]) {
    if (value != null) {
      _isDarkMode = value;
    } else {
      _isDarkMode = !_isDarkMode;
    }
    notifyListeners();
  }
}
