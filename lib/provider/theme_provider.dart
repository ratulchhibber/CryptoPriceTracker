import 'package:crypto_price_tracker/constant/local_storage.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeMode themeMode;

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
    LocalStorage.saveTheme(themeMode);
    notifyListeners();
  }
}
