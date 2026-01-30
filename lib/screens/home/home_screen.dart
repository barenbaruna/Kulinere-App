import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/providers/navigation_provider.dart';
import 'package:kulinere/providers/restaurant_list_provider.dart';
import 'package:kulinere/screens/detail/detail_screen.dart';
import 'package:kulinere/screens/home/widgets/restaurant_card.dart';
import 'package:kulinere/states/restaurant_list_state.dart';
import 'package:kulinere/widgets/error_widget.dart';
import 'package:kulinere/widgets/loading_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            _buildHeader(context, isDark),
            // Search Bar
            _buildSearchBar(context, isDark),
            // Restaurant List
            Expanded(
              child: Consumer<RestaurantListProvider>(
                builder: (context, provider, child) {
                  return switch (provider.state) {
                    RestaurantListNoneState() => const SizedBox(),
                    RestaurantListLoadingState() => const LoadingWidget(
                      message: 'Memuat daftar restoran...',
                    ),
                    RestaurantListLoadedState(data: final restaurants) =>
                      restaurants.isEmpty
                          ? _buildEmptyState(context)
                          : RefreshIndicator(
                              onRefresh: () => provider.fetchRestaurantList(),
                              color: AppColors.gold,
                              child: ListView.builder(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 100,
                                ),
                                itemCount: restaurants.length,
                                itemBuilder: (context, index) {
                                  final restaurant = restaurants[index];
                                  return RestaurantCard(
                                    restaurant: restaurant,
                                    onTap: () => _navigateToDetail(
                                      context,
                                      restaurant.id,
                                    ),
                                  );
                                },
                              ),
                            ),
                    RestaurantListErrorState(error: final message) =>
                      AppErrorWidget(
                        message: message,
                        onRetry: () => provider.fetchRestaurantList(),
                      ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Empty space for balance
          const SizedBox(width: 40),
          // App Title
          Text(
            'Kulinere',
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.goldVisible(isDark),
            ),
          ),
          // Notification Icon
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(milliseconds: 800),
                  content: Text('Notifikasi dalam pengembangan'),
                ),
              );
            },
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 28,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBackground
                            : AppColors.lightBackground,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          // Navigate to Search screen (tab index 1)
          context.read<NavigationProvider>().setIndex(1);
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                Icons.search,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Cari restoran atau lokasi...',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: AppColors.gold.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada restoran',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, String restaurantId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(restaurantId: restaurantId),
      ),
    );
  }
}
