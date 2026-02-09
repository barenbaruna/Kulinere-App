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

/// Search screen with debounced search, sorting, and city filtering.
///
/// Features:
/// - Real-time search with 300ms debounce
/// - Sort by default or rating
/// - Filter by city
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
    if (query.isEmpty) {
      context.read<RestaurantSearchProvider>().reset();
      return;
    }

    // Reset city filter when searching new term
    context.read<RestaurantSearchProvider>().setSelectedCity(null);
    _debouncer.run(() {
      context.read<RestaurantSearchProvider>().searchRestaurants(query);
    });
  }

  void _clearSearch() {
    _controller.clear();
    context.read<RestaurantSearchProvider>().reset();
    _focusNode.requestFocus();
  }

  List<String> _extractUniqueCities(List<Restaurant> restaurants) {
    final cities = <String>{};
    for (final r in restaurants) {
      cities.add(r.city);
    }
    return cities.toList()..sort();
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
                final state = provider.state;
                final cities = state is RestaurantSearchLoadedState
                    ? _extractUniqueCities(state.data)
                    : <String>[];

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeader(isDark, provider)),
                    SliverToBoxAdapter(child: _buildSearchBar(isDark)),
                    SliverToBoxAdapter(
                      child: _buildFilterChips(isDark, cities, provider),
                    ),
                    _buildResultCountSliver(provider, isDark),
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

  Widget _buildHeader(bool isDark, RestaurantSearchProvider provider) {
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

  Widget _buildFilterChips(
    bool isDark,
    List<String> cities,
    RestaurantSearchProvider provider,
  ) {
    final sortBy = provider.sortBy;
    final selectedCity = provider.selectedCity;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _FilterChip(
            label: 'Semua',
            isSelected: sortBy == 'default' && selectedCity == null,
            onTap: () {
              provider.setSortBy('default');
              provider.setSelectedCity(null);
            },
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Rating',
            isSelected: sortBy == 'rating',
            icon: Icons.star,
            onTap: () => provider.setSortBy('rating'),
          ),
          if (cities.length > 1) ...[
            const SizedBox(width: 8),
            _CityFilterChip(
              selectedCity: selectedCity,
              cities: cities,
              onCitySelected: (city) => provider.setSelectedCity(city),
              onClearFilter: () => provider.setSelectedCity(null),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultCountSliver(
    RestaurantSearchProvider provider,
    bool isDark,
  ) {
    final filtered = provider.result;
    final selectedCity = provider.selectedCity;

    if (filtered.isNotEmpty) {
      final cityLabel = selectedCity != null ? ' di $selectedCity' : '';

      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            '${filtered.length} restoran ditemukan$cityLabel',
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

      final filteredResults = provider.result;

      if (filteredResults.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: _buildNoResultsForCity(
            isDark,
            provider.selectedCity,
            provider,
          ),
        );
      }

      return SliverList.builder(
        itemCount: filteredResults.length,
        itemBuilder: (context, index) {
          final restaurant = filteredResults[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == filteredResults.length - 1 ? 100 : 0,
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

  Widget _buildNoResultsForCity(
    bool isDark,
    String? selectedCity,
    RestaurantSearchProvider provider,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 64,
            color: AppColors.gold.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada di $selectedCity',
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
          TextButton(
            onPressed: () => provider.setSelectedCity(null),
            child: Text(
              'Hapus filter kota',
              style: TextStyle(color: AppColors.goldVisible(isDark)),
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

/// City filter chip with dropdown menu.
class _CityFilterChip extends StatelessWidget {
  final String? selectedCity;
  final List<String> cities;
  final ValueChanged<String> onCitySelected;
  final VoidCallback onClearFilter;

  const _CityFilterChip({
    required this.selectedCity,
    required this.cities,
    required this.onCitySelected,
    required this.onClearFilter,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = selectedCity != null;

    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == '__clear__') {
          onClearFilter();
        } else {
          onCitySelected(value);
        }
      },
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
      itemBuilder: (context) => [
        if (selectedCity != null)
          PopupMenuItem<String>(
            value: '__clear__',
            child: Row(
              children: [
                Icon(Icons.clear, size: 16, color: AppColors.error),
                const SizedBox(width: 8),
                const Text('Hapus filter'),
              ],
            ),
          ),
        ...cities.map(
          (city) => PopupMenuItem<String>(
            value: city,
            child: Row(
              children: [
                Icon(
                  selectedCity == city
                      ? Icons.check_circle
                      : Icons.location_city,
                  size: 16,
                  color: selectedCity == city
                      ? AppColors.gold
                      : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                ),
                const SizedBox(width: 8),
                Text(
                  city,
                  style: TextStyle(
                    fontWeight: selectedCity == city
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
            Icon(
              Icons.location_on,
              size: 14,
              color: isSelected
                  ? AppColors.gold
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
            ),
            const SizedBox(width: 6),
            Text(
              selectedCity ?? 'Kota',
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
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: isSelected
                  ? AppColors.gold
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
