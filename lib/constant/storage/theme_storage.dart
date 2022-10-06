import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorage {
  Future<bool> save(ThemeMode value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setInt('theme', value.index);
  }

  Future<ThemeMode> fetch() async {
    final prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt('theme') ?? 1;
    return ThemeMode.values[index];
  }
}
