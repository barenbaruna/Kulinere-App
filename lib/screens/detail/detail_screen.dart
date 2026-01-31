import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/data/models/restaurant_detail.dart';
import 'package:kulinere/providers/restaurant_detail_provider.dart';
import 'package:kulinere/screens/detail/widgets/menu_section.dart';
import 'package:kulinere/screens/detail/widgets/restaurant_header.dart';
import 'package:kulinere/screens/detail/widgets/review_form.dart';
import 'package:kulinere/screens/detail/widgets/review_section.dart';
import 'package:kulinere/states/restaurant_detail_state.dart';
import 'package:kulinere/widgets/error_widget.dart';
import 'package:kulinere/widgets/loading_widget.dart';

/// Restaurant detail screen showing complete information.
///
/// Features:
/// - Hero image with back button
/// - Address and city info
/// - Category chips
/// - Description blockquote
/// - Food and drink menus
/// - Customer reviews with add review form
class DetailScreen extends StatefulWidget {
  final String restaurantId;
  final String heroTagPrefix;

  const DetailScreen({
    super.key,
    required this.restaurantId,
    this.heroTagPrefix = 'home',
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
        widget.restaurantId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, provider, child) {
          final state = provider.state;

          if (state is RestaurantDetailNoneState) {
            return const SizedBox();
          }
          if (state is RestaurantDetailLoadingState) {
            return const LoadingWidget(message: 'Memuat detail restoran...');
          }
          if (state is RestaurantDetailErrorState) {
            return AppErrorWidget(
              message: state.error,
              onRetry: () =>
                  provider.fetchRestaurantDetail(widget.restaurantId),
            );
          }
          if (state is RestaurantDetailLoadedState) {
            return _buildContent(context, state.data);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, RestaurantDetail restaurant) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
          widget.restaurantId,
        );
      },
      color: AppColors.goldVisible(isDark),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RestaurantHeader(
              restaurant: restaurant,
              heroTagPrefix: widget.heroTagPrefix,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildInfoSection(context, restaurant),
            ),
            if (restaurant.categories.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCategoriesSection(context, restaurant),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildDescriptionSection(context, restaurant, isDark),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: MenuSection(
                title: 'Makanan',
                icon: Icons.restaurant_menu,
                items: restaurant.menus.foods,
              ),
            ),
            const SizedBox(height: 24),
            MenuSection(
              title: 'Minuman',
              icon: Icons.local_cafe,
              items: restaurant.menus.drinks,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  ReviewSection(reviews: restaurant.customerReviews),
                  const SizedBox(height: 24),
                  Divider(
                    color: isDark
                        ? AppColors.darkDivider
                        : AppColors.lightDivider,
                  ),
                  const SizedBox(height: 16),
                  ReviewForm(restaurantId: restaurant.id),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, RestaurantDetail restaurant) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            context,
            Icons.location_on,
            'Alamat',
            restaurant.address,
            isDark,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            Icons.location_city,
            'Kota',
            restaurant.city,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.gold),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(
    BuildContext context,
    RestaurantDetail restaurant,
  ) {
    if (restaurant.categories.isEmpty) return const SizedBox();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: restaurant.categories
          .map<Widget>(
            (category) => Chip(
              label: Text(category.name),
              backgroundColor: AppColors.gold.withOpacity(0.2),
              side: BorderSide.none,
            ),
          )
          .toList(),
    );
  }

  Widget _buildDescriptionSection(
    BuildContext context,
    RestaurantDetail restaurant,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: AppColors.goldVisible(isDark), width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  color: AppColors.goldVisible(isDark),
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tentang Restoran',
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              restaurant.description,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.6),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
