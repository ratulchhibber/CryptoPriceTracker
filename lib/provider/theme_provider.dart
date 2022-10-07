import 'package:flutter/material.dart';

import '../constant/storage/theme_storage.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeMode themeMode;

  final ThemeStorage storage = ThemeStorage();

  ThemeProvider(this.themeMode) {
    _saveAndNotifyListeners();
  }

  void toggleTheme() {
    if (themeMode == ThemeMode.light) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
    _saveAndNotifyListeners();
  }

  void _saveAndNotifyListeners() {
    storage.save(themeMode);
    notifyListeners();
  }
}
