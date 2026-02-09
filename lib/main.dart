import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kulinere/core/background/workmanager_service.dart';
import 'package:kulinere/core/database/favorites_database_service.dart';
import 'package:kulinere/core/notifications/notification_service.dart';
import 'package:kulinere/core/preferences/preferences_service.dart';
import 'package:kulinere/core/theme/app_theme.dart';
import 'package:kulinere/data/api/api_service.dart';
import 'package:kulinere/providers/favorites_provider.dart';
import 'package:kulinere/providers/navigation_provider.dart';
import 'package:kulinere/providers/restaurant_detail_provider.dart';
import 'package:kulinere/providers/restaurant_list_provider.dart';
import 'package:kulinere/providers/restaurant_search_provider.dart';
import 'package:kulinere/providers/settings_provider.dart';
import 'package:kulinere/providers/user_profile_provider.dart';
import 'package:kulinere/screens/splash/splash_screen.dart';

/// Initialize services before runApp for immediate availability.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize preferences service
  final prefsService = PreferencesService();
  await prefsService.init();

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.init();

  // Initialize database service
  final dbService = FavoritesDatabaseService();

  // Initialize workmanager service
  final workmanagerService = WorkmanagerService();
  await workmanagerService.init();

  runApp(
    KulinereApp(
      prefsService: prefsService,
      notificationService: notificationService,
      workmanagerService: workmanagerService,
      dbService: dbService,
    ),
  );
}

class KulinereApp extends StatelessWidget {
  final PreferencesService prefsService;
  final NotificationService notificationService;
  final WorkmanagerService workmanagerService;
  final FavoritesDatabaseService dbService;

  const KulinereApp({
    super.key,
    required this.prefsService,
    required this.notificationService,
    required this.workmanagerService,
    required this.dbService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Core services
        Provider(create: (_) => ApiService()),
        Provider.value(value: dbService),
        Provider.value(value: prefsService),
        Provider.value(value: notificationService),
        Provider.value(value: workmanagerService),

        // Settings provider (must be before MaterialApp for themeMode)
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(
            prefsService,
            notificationService,
            workmanagerService,
          )..loadSettings(),
        ),

        // Favorites provider
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(dbService)..loadFavorites(),
        ),

        // API providers
        ChangeNotifierProvider(
          create: (ctx) => RestaurantListProvider(ctx.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => RestaurantDetailProvider(ctx.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => RestaurantSearchProvider(ctx.read<ApiService>()),
        ),

        // UI providers
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'Kulinere',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,
            themeAnimationDuration: const Duration(milliseconds: 500),
            themeAnimationCurve: Curves.easeInOut,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
