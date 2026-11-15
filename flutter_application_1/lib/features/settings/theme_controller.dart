import 'package:flutter/material.dart';

import '../../core/storage/preferences_service.dart';

class ThemeController extends ChangeNotifier {
  ThemeController(this._preferences) : _mode = _preferences.themeMode;

  final PreferencesService _preferences;
  ThemeMode _mode;

  ThemeMode get mode => _mode;

  bool get isDark => _mode == ThemeMode.dark;

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
    await _preferences.setThemeMode(mode);
  }

  Future<void> toggle() {
    return setMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}
