import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kulinere/core/background/workmanager_service.dart';
import 'package:kulinere/core/notifications/notification_service.dart';
import 'package:kulinere/core/preferences/preferences_service.dart';
import 'package:kulinere/providers/settings_provider.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

class MockNotificationService extends Mock implements NotificationService {}

class MockWorkmanagerService extends Mock implements WorkmanagerService {}

void main() {
  late SettingsProvider provider;
  late MockPreferencesService mockPrefsService;
  late MockNotificationService mockNotificationService;
  late MockWorkmanagerService mockWorkmanagerService;

  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
  });

  setUp(() {
    mockPrefsService = MockPreferencesService();
    mockNotificationService = MockNotificationService();
    mockWorkmanagerService = MockWorkmanagerService();
    provider = SettingsProvider(
      mockPrefsService,
      mockNotificationService,
      mockWorkmanagerService,
    );
  });

  group('SettingsProvider', () {
    test('loadSettings should load from preferences', () async {
      // Arrange
      when(() => mockPrefsService.getThemeMode()).thenReturn(ThemeMode.dark);
      when(() => mockPrefsService.getDailyReminderEnabled()).thenReturn(true);

      // Act
      await provider.loadSettings();

      // Assert
      expect(provider.themeMode, ThemeMode.dark);
      expect(provider.dailyReminderEnabled, true);
      verify(() => mockPrefsService.getThemeMode()).called(1);
      verify(() => mockPrefsService.getDailyReminderEnabled()).called(1);
    });

    test('setThemeMode should save to preferences', () async {
      // Arrange
      when(() => mockPrefsService.setThemeMode(any())).thenAnswer((_) async {});

      // Act
      await provider.setThemeMode(ThemeMode.light);

      // Assert
      expect(provider.themeMode, ThemeMode.light);
      verify(() => mockPrefsService.setThemeMode(ThemeMode.light)).called(1);
    });

    test(
      'setDailyReminderEnabled(true) should schedule daily task if permission granted',
      () async {
        // Arrange
        when(
          () => mockNotificationService.requestPermission(),
        ).thenAnswer((_) async => true);
        when(
          () => mockWorkmanagerService.registerDailyReminderTask(),
        ).thenAnswer((_) async {});
        when(
          () => mockPrefsService.setDailyReminderEnabled(any()),
        ).thenAnswer((_) async {});

        // Act
        await provider.setDailyReminderEnabled(true);

        // Assert
        expect(provider.dailyReminderEnabled, true);
        verify(
          () => mockWorkmanagerService.registerDailyReminderTask(),
        ).called(1);
        verify(() => mockPrefsService.setDailyReminderEnabled(true)).called(1);
      },
    );

    test(
      'setDailyReminderEnabled(true) should NOT schedule if permission denied',
      () async {
        // Arrange
        when(
          () => mockNotificationService.requestPermission(),
        ).thenAnswer((_) async => false);

        // Act
        await provider.setDailyReminderEnabled(true);

        // Assert
        expect(provider.dailyReminderEnabled, false);
        verifyNever(() => mockWorkmanagerService.registerDailyReminderTask());
        verifyNever(() => mockPrefsService.setDailyReminderEnabled(true));
      },
    );

    test('setDailyReminderEnabled(false) should cancel all tasks', () async {
      // Arrange
      when(
        () => mockWorkmanagerService.cancelAllTask(),
      ).thenAnswer((_) async {});
      when(
        () => mockPrefsService.setDailyReminderEnabled(any()),
      ).thenAnswer((_) async {});

      // Act
      await provider.setDailyReminderEnabled(false);

      // Assert
      expect(provider.dailyReminderEnabled, false);
      verify(() => mockWorkmanagerService.cancelAllTask()).called(1);
      verify(() => mockPrefsService.setDailyReminderEnabled(false)).called(1);
    });
  });
}
