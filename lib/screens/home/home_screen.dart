import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/data/models/restaurant.dart';
import 'package:kulinere/providers/navigation_provider.dart';
import 'package:kulinere/providers/restaurant_list_provider.dart';
import 'package:kulinere/providers/user_profile_provider.dart';
import 'package:kulinere/screens/detail/detail_screen.dart';
import 'package:kulinere/screens/home/widgets/restaurant_card.dart';
import 'package:kulinere/states/restaurant_list_state.dart';
import 'package:kulinere/widgets/error_widget.dart';
import 'package:kulinere/widgets/loading_widget.dart';
import 'package:kulinere/widgets/location_card.dart';
import 'package:kulinere/widgets/profile_avatar.dart';

/// Home screen displaying restaurant list with city filtering.
///
/// Features:
/// - Dynamic greeting based on time of day
/// - Horizontal scrollable city filter cards
/// - Pull-to-refresh restaurant list
/// - Search bar navigation to Jelajahi tab
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Consumer<RestaurantListProvider>(
          builder: (context, provider, child) {
            return switch (provider.state) {
              RestaurantListNoneState() => const SizedBox(),
              RestaurantListLoadingState() => const LoadingWidget(
                message: 'Memuat daftar restoran...',
              ),
              RestaurantListLoadedState(data: final allRestaurants) =>
                _buildContent(context, allRestaurants, provider, isDark),
              RestaurantListErrorState(error: final message) => AppErrorWidget(
                message: message,
                onRetry: () => provider.fetchRestaurantList(),
              ),
            };
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<Restaurant> allRestaurants,
    RestaurantListProvider provider,
    bool isDark,
  ) {
    final cityMap = <String, int>{};
    for (final r in allRestaurants) {
      cityMap[r.city] = (cityMap[r.city] ?? 0) + 1;
    }
    final uniqueCities = cityMap.keys.toList();

    // Use filtered list from provider
    final displayedRestaurants = provider.restaurants;
    final selectedCity = provider.selectedCity;

    return RefreshIndicator(
      onRefresh: () => provider.fetchRestaurantList(),
      color: AppColors.goldVisible(isDark),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context, isDark)),
          SliverToBoxAdapter(child: _buildGreeting(context, isDark)),
          SliverToBoxAdapter(child: _buildSearchBar(context, isDark)),
          SliverToBoxAdapter(
            child: _buildLocationSection(
              context,
              isDark,
              uniqueCities,
              cityMap,
              provider,
            ),
          ),
          SliverToBoxAdapter(
            child: _buildRestaurantCountHeader(
              context,
              isDark,
              displayedRestaurants.length,
              selectedCity,
            ),
          ),
          displayedRestaurants.isEmpty
              ? SliverFillRemaining(
                  child: _buildEmptyState(context, selectedCity),
                )
              : SliverPadding(
                  padding: const EdgeInsets.only(bottom: 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final restaurant = displayedRestaurants[index];
                      return RestaurantCard(
                        restaurant: restaurant,
                        onTap: () => _navigateToDetail(context, restaurant.id),
                      );
                    }, childCount: displayedRestaurants.length),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final goldColor = AppColors.goldVisible(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
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
                      color: goldColor,
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
          Expanded(
            child: Text(
              'Kulinere',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: goldColor,
              ),
            ),
          ),
          ProfileAvatar(
            size: 36,
            onTap: () => context.read<NavigationProvider>().setIndex(3),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Consumer<UserProfileProvider>(
        builder: (context, userProvider, child) {
          return Text(
            userProvider.fullGreeting,
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    final goldColor = AppColors.goldVisible(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GestureDetector(
        onTap: () {
          context.read<NavigationProvider>().setIndex(1, focusSearch: true);
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
              Icon(Icons.search, color: goldColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Cari restoran atau lokasi...',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection(
    BuildContext context,
    bool isDark,
    List<String> cities,
    Map<String, int> cityMap,
    RestaurantListProvider provider,
  ) {
    final goldColor = AppColors.goldVisible(isDark);
    final selectedCity = provider.selectedCity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Jelajahi ${cities.length} kota kuliner',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
              if (selectedCity != null)
                TextButton.icon(
                  onPressed: () => provider.setSelectedCity(null),
                  icon: Icon(Icons.clear, size: 16, color: goldColor),
                  label: Text(
                    'Semua',
                    style: TextStyle(color: goldColor, fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120, // Increased height to prevent overflow
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cities.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final city = cities[index];
              return LocationCard(
                city: city,
                restaurantCount: cityMap[city] ?? 0,
                isSelected: selectedCity == city,
                onTap: () {
                  provider.setSelectedCity(selectedCity == city ? null : city);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRestaurantCountHeader(
    BuildContext context,
    bool isDark,
    int count,
    String? selectedCity,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 18,
            color: AppColors.goldVisible(isDark),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              selectedCity != null
                  ? '$count pilihan kuliner di $selectedCity'
                  : '$count pilihan kuliner menanti',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String? selectedCity) {
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
          if (selectedCity != null) ...[
            const SizedBox(height: 8),
            Text(
              'di $selectedCity',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
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
