import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static const String _themeKey = 'isDarkMode';

  static Future<bool> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  static Future<void> setThemeMode(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, isDarkMode);
  }

  static ThemeData getLightTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
    );
  }
}
