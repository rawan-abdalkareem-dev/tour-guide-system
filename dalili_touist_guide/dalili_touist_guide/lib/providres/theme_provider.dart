// lib/providres/theme_provider.dart
import 'package:flutter/material.dart';
import '../core/storage/preferences_service.dart';
import '../core/theme/app_theme.dart';

/// Provider dedicated to theme mode (Light/Dark).
/// Decoupled from user state so theme changes update MaterialApp without touching auth state.
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode;

  ThemeProvider() : _isDarkMode = PreferencesService.darkMode;

  /// Whether dark mode is currently active
  bool get isDarkMode => _isDarkMode;

  /// The active ThemeMode enum for MaterialApp
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Light ThemeData
  ThemeData get lightTheme => AppTheme.lightTheme;

  /// Dark ThemeData
  ThemeData get darkTheme => AppTheme.darkTheme;

  /// Currently active ThemeData based on [isDarkMode]
  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  /// Switches dark mode on or off and persists to SharedPreferences
  Future<void> setDarkMode(bool isDark) async {
    if (_isDarkMode == isDark) return;
    _isDarkMode = isDark;
    notifyListeners();
    await PreferencesService.setDarkMode(isDark);
  }

  /// Toggles between light and dark mode
  Future<void> toggleTheme() async {
    await setDarkMode(!_isDarkMode);
  }

  /// Resets theme settings to default (Light mode)
  Future<void> reset() async {
    _isDarkMode = false;
    notifyListeners();
    await PreferencesService.setDarkMode(false);
  }
}
