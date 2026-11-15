import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService._(this._prefs);

  static const String _apiKeyKey = 'api_key_v1';
  static const String _themeKey = 'theme_mode_v1';
  static const String _onboardingKey = 'onboarding_seen_v1';
  static const String _favoritesKey = 'favorites_v1';
  static const String _workoutKey = 'workout_v1';

  final SharedPreferences _prefs;

  static Future<PreferencesService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService._(prefs);
  }

  String? get apiKey {
    final value = _prefs.getString(_apiKeyKey)?.trim();
    return (value == null || value.isEmpty) ? null : value;
  }

  Future<void> setApiKey(String? value) async {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      await _prefs.remove(_apiKeyKey);
    } else {
      await _prefs.setString(_apiKeyKey, normalized);
    }
  }

  bool get onboardingSeen => _prefs.getBool(_onboardingKey) ?? false;

  Future<void> markOnboardingSeen() async {
    await _prefs.setBool(_onboardingKey, true);
  }

  ThemeMode get themeMode {
    switch (_prefs.getString(_themeKey)) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.name);
  }

  String? readRaw(String key) => _prefs.getString(key);

  Future<void> writeRaw(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<void> removeRaw(String key) async {
    await _prefs.remove(key);
  }

  static String get favoritesKey => _favoritesKey;
  static String get workoutKey => _workoutKey;
}
