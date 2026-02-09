import 'package:flutter/material.dart';
import 'package:kulinere/core/background/workmanager_service.dart';
import 'package:kulinere/core/notifications/notification_service.dart';
import 'package:kulinere/core/preferences/preferences_service.dart';

/// Manages app settings with SharedPreferences persistence.
///
/// Features:
/// - Theme mode (light/dark/system) with persistence
/// - Daily reminder toggle with notification scheduling
/// - Loads settings before runApp() for immediate availability
class SettingsProvider extends ChangeNotifier {
  final PreferencesService _prefsService;
  final NotificationService _notificationService;
  final WorkmanagerService _workmanagerService;

  SettingsProvider(
    this._prefsService,
    this._notificationService,
    this._workmanagerService,
  );

  ThemeMode _themeMode = ThemeMode.system;
  bool _dailyReminderEnabled = false;

  /// Current theme mode for MaterialApp.
  ThemeMode get themeMode => _themeMode;

  /// Whether daily reminder notification is enabled.
  bool get dailyReminderEnabled => _dailyReminderEnabled;

  /// Loads all settings from SharedPreferences.
  Future<void> loadSettings() async {
    _themeMode = _prefsService.getThemeMode();
    _dailyReminderEnabled = _prefsService.getDailyReminderEnabled();
    notifyListeners();
  }

  /// Sets theme mode and persists to SharedPreferences.
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefsService.setThemeMode(mode);
    notifyListeners();
  }

  /// Enables/disables daily reminder notification.
  ///
  /// When enabled, schedules periodic background task using Workmanager.
  /// When disabled, cancels all background tasks.
  Future<void> setDailyReminderEnabled(bool enabled) async {
    if (enabled) {
      final granted = await _notificationService.requestPermission();
      if (!granted) {
        // Permission denied, don't enable
        return;
      }

      await _workmanagerService.registerDailyReminderTask();
    } else {
      await _workmanagerService.cancelAllTask();
    }

    _dailyReminderEnabled = enabled;
    await _prefsService.setDailyReminderEnabled(enabled);
    notifyListeners();
  }

  /// Triggers an immediate test notification with random restaurant.
  /// Use this for testing without waiting for 11:00 AM.
  Future<void> showTestNotification() async {
    final granted = await _notificationService.requestPermission();
    if (granted) {
      await _workmanagerService.testImmediateNotification();
    }
  }
}
