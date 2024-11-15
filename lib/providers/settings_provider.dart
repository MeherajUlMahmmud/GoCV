import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  // Theme mode and language settings
  ThemeMode _themeMode = ThemeMode.system;
  String _language = 'en';

  // Keys for SharedPreferences
  static const String themeModeKey = 'theme_mode';
  static const String languageKey = 'language';

  SettingsProvider() {
    _loadSettings();
  }

  // Getters
  ThemeMode get themeMode => _themeMode;
  String get language => _language;

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = _getThemeModeFromString(prefs.getString(themeModeKey) ?? 'system');
    _language = prefs.getString(languageKey) ?? 'en';
    notifyListeners();
  }

  // Save theme mode
  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(themeModeKey, _themeMode.toString().split('.').last);
    notifyListeners();
  }

  // Save language
  Future<void> setLanguage(String language) async {
    _language = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, _language);
    notifyListeners();
  }

  // Helper to convert string to ThemeMode
  ThemeMode _getThemeModeFromString(String themeString) {
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
