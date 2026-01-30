import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/providers/navigation_provider.dart';
import 'package:kulinere/screens/bookmark/bookmark_screen.dart';
import 'package:kulinere/screens/home/home_screen.dart';
import 'package:kulinere/screens/profile/profile_screen.dart';
import 'package:kulinere/screens/search/search_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    BookmarkScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Consumer<NavigationProvider>(
        builder: (context, navProvider, child) {
          return Scaffold(
            body: IndexedStack(
              index: navProvider.currentIndex,
              children: _screens,
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.darkDivider
                        : AppColors.lightDivider,
                    width: 0.5,
                  ),
                ),
              ),
              child: NavigationBar(
                selectedIndex: navProvider.currentIndex,
                onDestinationSelected: (index) => navProvider.setIndex(index),
                indicatorColor: AppColors.gold.withOpacity(0.2),
                backgroundColor: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                destinations: [
                  NavigationDestination(
                    icon: Icon(
                      Icons.home_outlined,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    selectedIcon: Icon(Icons.home, color: AppColors.gold),
                    label: 'Beranda',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.search_outlined,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    selectedIcon: Icon(Icons.search, color: AppColors.gold),
                    label: 'Jelajahi',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.bookmark_outline,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    selectedIcon: Icon(Icons.bookmark, color: AppColors.gold),
                    label: 'Favorit',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.person_outline,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    selectedIcon: Icon(Icons.person, color: AppColors.gold),
                    label: 'Profil',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
