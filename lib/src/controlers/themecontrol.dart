import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeControl extends ChangeNotifier {
  static ThemeControl instance = ThemeControl();

  bool isDarkTheme = false;

  ThemeControl() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    notifyListeners();
  }

  Future<void> changeTheme() async {
    isDarkTheme = !isDarkTheme;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDarkTheme);
  }
}