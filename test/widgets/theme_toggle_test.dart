import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kulinere/core/background/workmanager_service.dart';
import 'package:kulinere/core/notifications/notification_service.dart';
import 'package:kulinere/core/preferences/preferences_service.dart';
import 'package:kulinere/providers/settings_provider.dart';

/// Mock for PreferencesService
class MockPreferencesService extends Mock implements PreferencesService {}

/// Mock for NotificationService
class MockNotificationService extends Mock implements NotificationService {}

/// Mock for WorkmanagerService
class MockWorkmanagerService extends Mock implements WorkmanagerService {}

void main() {
  late MockPreferencesService mockPrefsService;
  late MockNotificationService mockNotificationService;
  late MockWorkmanagerService mockWorkmanagerService;
  late SettingsProvider provider;

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

  Widget createTestWidget({required Widget child}) {
    return MaterialApp(
      home: ChangeNotifierProvider<SettingsProvider>.value(
        value: provider,
        child: Scaffold(body: child),
      ),
    );
  }

  group('Theme Toggle Widget Tests', () {
    testWidgets('should display current theme mode', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockPrefsService.getThemeMode()).thenReturn(ThemeMode.light);
      when(() => mockPrefsService.getDailyReminderEnabled()).thenReturn(false);
      await provider.loadSettings();

      // Act
      await tester.pumpWidget(
        createTestWidget(
          child: Consumer<SettingsProvider>(
            builder: (context, settings, _) {
              return Column(
                children: [
                  Text('Current: ${settings.themeMode.name}'),
                  RadioListTile<ThemeMode>(
                    title: const Text('Light'),
                    value: ThemeMode.light,
                    groupValue: settings.themeMode,
                    onChanged: (mode) => settings.setThemeMode(mode!),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark'),
                    value: ThemeMode.dark,
                    groupValue: settings.themeMode,
                    onChanged: (mode) => settings.setThemeMode(mode!),
                  ),
                ],
              );
            },
          ),
        ),
      );

      // Assert
      expect(find.text('Current: light'), findsOneWidget);
    });

    testWidgets('should change theme when radio button is selected', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockPrefsService.getThemeMode()).thenReturn(ThemeMode.light);
      when(() => mockPrefsService.getDailyReminderEnabled()).thenReturn(false);
      when(() => mockPrefsService.setThemeMode(any())).thenAnswer((_) async {});
      await provider.loadSettings();

      await tester.pumpWidget(
        createTestWidget(
          child: Consumer<SettingsProvider>(
            builder: (context, settings, _) {
              return Column(
                children: [
                  Text('Current: ${settings.themeMode.name}'),
                  RadioListTile<ThemeMode>(
                    key: const Key('dark_radio'),
                    title: const Text('Dark'),
                    value: ThemeMode.dark,
                    groupValue: settings.themeMode,
                    onChanged: (mode) => settings.setThemeMode(mode!),
                  ),
                ],
              );
            },
          ),
        ),
      );

      // Initially light
      expect(find.text('Current: light'), findsOneWidget);

      // Act - tap dark mode
      await tester.tap(find.byKey(const Key('dark_radio')));
      await tester.pumpAndSettle();

      // Assert - should now be dark
      expect(find.text('Current: dark'), findsOneWidget);
      verify(() => mockPrefsService.setThemeMode(ThemeMode.dark)).called(1);
    });
  });
}
