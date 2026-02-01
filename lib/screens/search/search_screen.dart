import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/core/utils/debouncer.dart';
import 'package:kulinere/data/models/restaurant.dart';
import 'package:kulinere/providers/navigation_provider.dart';
import 'package:kulinere/providers/restaurant_search_provider.dart';
import 'package:kulinere/screens/detail/detail_screen.dart';
import 'package:kulinere/screens/home/widgets/restaurant_card.dart';
import 'package:kulinere/states/restaurant_search_state.dart';
import 'package:kulinere/widgets/error_widget.dart';

/// Search screen with debounced search and sorting functionality.
///
/// Features:
/// - Real-time search with 300ms debounce
/// - Sort by default or rating
/// - Auto-focus when navigating from home search bar
/// - CustomScrollView + Slivers for overflow prevention
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _debouncer = Debouncer();
  final _focusNode = FocusNode();
  String _sortBy = 'default';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkFocusSignal();
  }

  void _checkFocusSignal() {
    final navProvider = context.read<NavigationProvider>();
    if (navProvider.shouldFocusSearch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
      navProvider.clearSearchFocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debouncer.run(() {
      context.read<RestaurantSearchProvider>().searchRestaurants(query);
    });
  }

  void _clearSearch() {
    _controller.clear();
    context.read<RestaurantSearchProvider>().reset();
    _focusNode.requestFocus();
  }

  List<Restaurant> _sortResults(List<Restaurant> restaurants) {
    if (_sortBy == 'rating') {
      return [...restaurants]..sort((a, b) => b.rating.compareTo(a.rating));
    }
    return restaurants;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<NavigationProvider>(
      builder: (context, navProvider, child) {
        if (navProvider.shouldFocusSearch) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _focusNode.requestFocus();
          });
          navProvider.clearSearchFocus();
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Consumer<RestaurantSearchProvider>(
              builder: (context, provider, child) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeader(isDark)),
                    SliverToBoxAdapter(child: _buildSearchBar(isDark)),
                    SliverToBoxAdapter(child: _buildFilterChips(isDark)),
                    _buildResultCountSliver(provider.state, isDark),
                    _buildResultsSliver(provider, isDark),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Text(
        'Jelajahi',
        style: TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.goldVisible(isDark),
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
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
            Icon(Icons.search, color: AppColors.goldVisible(isDark), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Cari restoran, kota, atau makanan...',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 14,
                  ),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: _onSearchChanged,
              ),
            ),
            if (_controller.text.isNotEmpty)
              IconButton(
                icon: Icon(
                  Icons.clear,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                onPressed: _clearSearch,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _FilterChip(
            label: 'Semua',
            isSelected: _sortBy == 'default',
            onTap: () => setState(() => _sortBy = 'default'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Rating Tertinggi',
            isSelected: _sortBy == 'rating',
            icon: Icons.star,
            onTap: () => setState(() => _sortBy = 'rating'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCountSliver(RestaurantSearchState state, bool isDark) {
    if (state is RestaurantSearchLoadedState && state.data.isNotEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            '${state.founded} restoran ditemukan',
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox(height: 12));
  }

  Widget _buildResultsSliver(RestaurantSearchProvider provider, bool isDark) {
    final state = provider.state;

    if (state is RestaurantSearchNoneState) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildEmptyHint(isDark),
      );
    }

    if (state is RestaurantSearchLoadingState) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildLoadingState(isDark),
      );
    }

    if (state is RestaurantSearchErrorState) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: AppErrorWidget(
          message: state.error,
          onRetry: () => provider.searchRestaurants(provider.lastQuery),
        ),
      );
    }

    if (state is RestaurantSearchLoadedState) {
      if (state.data.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: _buildNoResults(provider.lastQuery, isDark),
        );
      }

      final sortedResults = _sortResults(state.data);
      return SliverList.builder(
        itemCount: sortedResults.length,
        itemBuilder: (context, index) {
          final restaurant = sortedResults[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == sortedResults.length - 1 ? 100 : 0,
            ),
            child: RestaurantCard(
              restaurant: restaurant,
              heroTagPrefix: 'search',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    restaurantId: restaurant.id,
                    heroTagPrefix: 'search',
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return const SliverToBoxAdapter(child: SizedBox());
  }

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.goldVisible(isDark)),
          ),
          const SizedBox(height: 16),
          Text(
            'Mencari restoran...',
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHint(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: AppColors.gold.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'Temukan restoran favoritmu',
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ketik untuk mulai mencari',
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(String query, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: AppColors.gold.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ditemukan',
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Restoran "$query" tidak ditemukan.\nCoba kata kunci lain.',
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// Filter chip widget for sort options.
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData? icon;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.gold.withOpacity(0.2)
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.gold
                : (isDark ? AppColors.darkDivider : AppColors.lightDivider),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected
                    ? AppColors.gold
                    : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppColors.gold
                    : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
