import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:kulinere/static/my_workmanager.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

/// Background task callback for WorkManager.
///
/// Executes when scheduled task fires:
/// 1. Fetches random restaurant from API
/// 2. Shows notification with restaurant recommendation
/// 3. Re-schedules itself for next day 11:00 AM
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == MyWorkmanager.dailyReminder.taskName) {
      try {
        // Initialize notification plugin in background isolate
        final plugin = FlutterLocalNotificationsPlugin();
        const androidSettings = AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        );
        const iosSettings = DarwinInitializationSettings();
        const initSettings = InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        );
        await plugin.initialize(initSettings);

        // Fetch restaurant list from API
        final response = await http.get(
          Uri.parse('https://restaurant-api.dicoding.dev/list'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List<dynamic> restaurants = data['restaurants'];

          if (restaurants.isNotEmpty) {
            // Pick random restaurant
            final random = Random();
            final restaurant = restaurants[random.nextInt(restaurants.length)];
            final String name = restaurant['name'];
            final String city = restaurant['city'];
            final double rating = (restaurant['rating'] as num).toDouble();

            // Show notification
            const androidDetails = AndroidNotificationDetails(
              'kulinere_reminder',
              'Daily Reminder',
              channelDescription: 'Daily lunch reminder notifications',
              importance: Importance.high,
              priority: Priority.high,
            );
            const notificationDetails = NotificationDetails(
              android: androidDetails,
              iOS: DarwinNotificationDetails(),
            );

            await plugin.show(
              1,
              'Waktunya Makan Siang! 🍽️',
              'Coba kunjungi $name di $city - Rating $rating ⭐',
              notificationDetails,
            );
          }
        }

        // Re-schedule for tomorrow 11:00 AM
        await _scheduleNextDailyReminder();
      } catch (e) {
        debugPrint('Background task error: $e');
      }
    }
    return Future.value(true);
  });
}

/// Schedules task for next occurrence of 11:00 AM.
Future<void> _scheduleNextDailyReminder() async {
  final now = DateTime.now();
  var target = DateTime(now.year, now.month, now.day + 1, 11, 0);
  final delay = target.difference(now);

  await Workmanager().registerOneOffTask(
    MyWorkmanager.dailyReminder.uniqueName,
    MyWorkmanager.dailyReminder.taskName,
    initialDelay: delay,
    existingWorkPolicy: ExistingWorkPolicy.replace,
    constraints: Constraints(networkType: NetworkType.connected),
  );

  debugPrint('Daily reminder rescheduled for: $target (delay: $delay)');
}

/// Service for managing WorkManager background tasks.
class WorkmanagerService {
  final Workmanager _workmanager;

  /// Notification plugin for exact-time scheduling.
  FlutterLocalNotificationsPlugin? _notificationPlugin;

  WorkmanagerService([Workmanager? workmanager])
    : _workmanager = workmanager ?? Workmanager();

  /// Initializes WorkManager with callback dispatcher.
  Future<void> init() async {
    await _workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );

    // Initialize timezone for exact scheduling
    tz.initializeTimeZones();
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Initialize notification plugin
    _notificationPlugin = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _notificationPlugin!.initialize(initSettings);
  }

  /// Registers daily reminder using hybrid approach:
  /// 1. zonedSchedule for EXACT 11:00 AM timing
  /// 2. WorkManager as backup for API data fetch
  Future<void> registerDailyReminderTask() async {
    // 1. Schedule exact-time notification using zonedSchedule
    await _scheduleExactNotification();

    // 2. Also register WorkManager task as backup
    await _registerWorkmanagerBackup();

    debugPrint('Daily reminder registered with hybrid approach');
  }

  /// Schedules exact notification at 11:00 AM using zonedSchedule.
  Future<void> _scheduleExactNotification() async {
    if (_notificationPlugin == null) return;

    const androidDetails = AndroidNotificationDetails(
      'kulinere_reminder',
      'Daily Reminder',
      channelDescription: 'Daily lunch reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    final scheduledTime = _nextInstanceOfElevenAM();

    await _notificationPlugin!.zonedSchedule(
      1, // Notification ID
      'Waktunya Makan Siang! 🍽️',
      'Saatnya istirahat dan menikmati hidangan lezat di restoran favoritmu!',
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    debugPrint('Exact notification scheduled for: $scheduledTime');
  }

  /// Returns the next occurrence of 11:00 AM.
  tz.TZDateTime _nextInstanceOfElevenAM() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Registers WorkManager task as backup for API fetch.
  Future<void> _registerWorkmanagerBackup() async {
    final now = DateTime.now();
    var target = DateTime(now.year, now.month, now.day, 11, 0);

    // If 11:00 AM already passed today, schedule for tomorrow
    if (target.isBefore(now)) {
      target = target.add(const Duration(days: 1));
    }

    final delay = target.difference(now);

    await _workmanager.registerOneOffTask(
      MyWorkmanager.dailyReminder.uniqueName,
      MyWorkmanager.dailyReminder.taskName,
      initialDelay: delay,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(networkType: NetworkType.connected),
    );

    debugPrint('WorkManager backup scheduled for: $target (delay: $delay)');
  }

  /// Cancels all scheduled background tasks and notifications.
  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
    await _notificationPlugin?.cancel(1);
    debugPrint('All background tasks and notifications cancelled');
  }

  /// Triggers immediate test notification with random restaurant.
  /// Use this for testing without waiting for 11:00 AM.
  Future<void> testImmediateNotification() async {
    try {
      // Fetch restaurant from API
      final response = await http.get(
        Uri.parse('https://restaurant-api.dicoding.dev/list'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> restaurants = data['restaurants'];

        if (restaurants.isNotEmpty) {
          final random = Random();
          final restaurant = restaurants[random.nextInt(restaurants.length)];
          final String name = restaurant['name'];
          final String city = restaurant['city'];
          final double rating = (restaurant['rating'] as num).toDouble();

          const androidDetails = AndroidNotificationDetails(
            'kulinere_reminder',
            'Daily Reminder',
            channelDescription: 'Daily lunch reminder notifications',
            importance: Importance.high,
            priority: Priority.high,
          );

          const notificationDetails = NotificationDetails(
            android: androidDetails,
            iOS: DarwinNotificationDetails(),
          );

          await _notificationPlugin?.show(
            99, // Different ID for test
            'Waktunya Makan Siang! 🍽️',
            'Coba kunjungi $name di $city - Rating $rating ⭐',
            notificationDetails,
          );

          debugPrint('Test notification shown with restaurant: $name');
        }
      }
    } catch (e) {
      debugPrint('Test notification error: $e');
    }
  }
}
