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

class DetailScreen extends StatefulWidget {
  final String restaurantId;

  const DetailScreen({super.key, required this.restaurantId});

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
              onRetry: () => provider.fetchRestaurantDetail(widget.restaurantId),
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RestaurantHeader(restaurant: restaurant),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoSection(context, restaurant),
                const SizedBox(height: 24),
                _buildCategoriesSection(context, restaurant),
                const SizedBox(height: 24),
                Text(
                  'Deskripsi',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  restaurant.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 24),
                MenuSection(
                  title: 'Makanan',
                  icon: Icons.restaurant_menu,
                  items: restaurant.menus.foods,
                ),
                const SizedBox(height: 24),
                MenuSection(
                  title: 'Minuman',
                  icon: Icons.local_cafe,
                  items: restaurant.menus.drinks,
                ),
                const SizedBox(height: 24),
                ReviewSection(reviews: restaurant.customerReviews),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                ReviewForm(
                  restaurantId: restaurant.id,
                  onSubmitted: () {
                    context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
                      restaurant.id,
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, RestaurantDetail restaurant) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, size: 20, color: AppColors.gold),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    restaurant.address,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_city, size: 20, color: AppColors.gold),
                const SizedBox(width: 8),
                Text(
                  restaurant.city,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context, RestaurantDetail restaurant) {
    if (restaurant.categories.isEmpty) return const SizedBox();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: restaurant.categories.map<Widget>((category) => Chip(
        label: Text(category.name),
        backgroundColor: AppColors.gold.withOpacity(0.2),
        side: BorderSide.none,
      )).toList(),
    );
  }
}
