import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<bool> saveTheme(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setInt('theme', theme.index);
  }

  static Future<ThemeMode> fetchTheme() async {
    final prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt('theme') ?? 1;
    return ThemeMode.values[index];
  }
}
