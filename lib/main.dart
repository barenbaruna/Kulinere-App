import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kulinere/core/theme/app_theme.dart';
import 'package:kulinere/data/api/api_service.dart';
import 'package:kulinere/providers/bookmark_provider.dart';
import 'package:kulinere/providers/navigation_provider.dart';
import 'package:kulinere/providers/restaurant_detail_provider.dart';
import 'package:kulinere/providers/restaurant_list_provider.dart';
import 'package:kulinere/providers/restaurant_search_provider.dart';
import 'package:kulinere/providers/user_profile_provider.dart';
import 'package:kulinere/screens/splash/splash_screen.dart';

void main() {
  runApp(const KulinereApp());
}

/// Root application widget with provider configuration.
///
/// Sets up:
/// - MultiProvider with all app providers
/// - Material theme (light/dark based on system)
/// - SplashScreen as initial route
class KulinereApp extends StatelessWidget {
  const KulinereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        ChangeNotifierProvider(
          create: (ctx) => RestaurantListProvider(ctx.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => RestaurantDetailProvider(ctx.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => RestaurantSearchProvider(ctx.read<ApiService>()),
        ),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Kulinere',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}
