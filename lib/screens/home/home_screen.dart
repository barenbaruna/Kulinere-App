import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kulinere'),
      ),
      body: Consumer<RestaurantListProvider>(
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
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: restaurants.length,
                          itemBuilder: (context, index) {
                            final restaurant = restaurants[index];
                            return RestaurantCard(
                              restaurant: restaurant,
                              onTap: () => _navigateToDetail(context, restaurant.id),
                            );
                          },
                        ),
                      ),
            RestaurantListErrorState(error: final message) => AppErrorWidget(
                message: message,
                onRetry: () => provider.fetchRestaurantList(),
              ),
          };
        },
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
            color: Theme.of(context).colorScheme.secondary,
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
