import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/providers/navigation_provider.dart';
import 'package:kulinere/screens/bookmark/bookmark_screen.dart';
import 'package:kulinere/screens/home/home_screen.dart';
import 'package:kulinere/screens/profile/profile_screen.dart';
import 'package:kulinere/screens/search/search_screen.dart';

/// Main screen with bottom navigation and IndexedStack for tab persistence.
///
/// Uses [NavigationProvider] for tab state management.
/// Status bar styling adapts to current theme mode.
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
            bottomNavigationBar: _buildBottomNav(context, navProvider, isDark),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav(
    BuildContext context,
    NavigationProvider navProvider,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            width: 0.5,
          ),
        ),
      ),
      child: NavigationBar(
        height: 60,
        selectedIndex: navProvider.currentIndex,
        onDestinationSelected: (index) => navProvider.setIndex(index),
        indicatorColor: AppColors.gold.withOpacity(0.2),
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        destinations: [
          _buildNavItem(Icons.home_outlined, Icons.home, 'Beranda', isDark),
          _buildNavItem(
            Icons.search_outlined,
            Icons.search,
            'Jelajahi',
            isDark,
          ),
          _buildNavItem(
            Icons.bookmark_outline,
            Icons.bookmark,
            'Favorit',
            isDark,
          ),
          _buildNavItem(Icons.person_outline, Icons.person, 'Profil', isDark),
        ],
      ),
    );
  }

  NavigationDestination _buildNavItem(
    IconData icon,
    IconData selectedIcon,
    String label,
    bool isDark,
  ) {
    return NavigationDestination(
      icon: Icon(
        icon,
        color: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
      ),
      selectedIcon: Icon(selectedIcon, color: AppColors.gold),
      label: label,
    );
  }
}
