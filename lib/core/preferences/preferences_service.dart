import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app preferences using SharedPreferences.
///
/// Features:
/// - Theme mode persistence (light/dark/system)
/// - Daily reminder toggle persistence
class PreferencesService {
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyDailyReminder = 'daily_reminder';

  SharedPreferences? _prefs;

  /// Initializes SharedPreferences instance.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Returns the saved theme mode.
  ThemeMode getThemeMode() {
    final value = _prefs?.getString(_keyThemeMode) ?? 'system';
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  /// Saves the theme mode preference.
  Future<void> setThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs?.setString(_keyThemeMode, value);
  }

  /// Returns whether daily reminder is enabled.
  bool getDailyReminderEnabled() {
    return _prefs?.getBool(_keyDailyReminder) ?? false;
  }

  /// Saves the daily reminder preference.
  Future<void> setDailyReminderEnabled(bool enabled) async {
    await _prefs?.setBool(_keyDailyReminder, enabled);
  }
}
