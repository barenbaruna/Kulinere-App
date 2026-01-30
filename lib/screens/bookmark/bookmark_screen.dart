import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/data/models/restaurant.dart';
import 'package:kulinere/providers/bookmark_provider.dart';
import 'package:kulinere/providers/restaurant_list_provider.dart';
import 'package:kulinere/screens/detail/detail_screen.dart';
import 'package:kulinere/screens/home/widgets/restaurant_card.dart';
import 'package:kulinere/states/restaurant_list_state.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit'),
      ),
      body: Consumer2<BookmarkProvider, RestaurantListProvider>(
        builder: (context, bookmarkProvider, listProvider, child) {
          final bookmarkedIds = bookmarkProvider.bookmarkedIds;

          if (bookmarkedIds.isEmpty) {
            return _buildEmptyState(context);
          }

          final listState = listProvider.state;
          if (listState is! RestaurantListLoadedState) {
            return _buildEmptyState(context);
          }

          final bookmarkedRestaurants = listState.data
              .where((r) => bookmarkedIds.contains(r.id))
              .toList();

          if (bookmarkedRestaurants.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: bookmarkedRestaurants.length,
            itemBuilder: (context, index) {
              final restaurant = bookmarkedRestaurants[index];
              return _BookmarkCard(
                restaurant: restaurant,
                onTap: () => _navigateToDetail(context, restaurant.id),
                onRemove: () => bookmarkProvider.removeBookmark(restaurant.id),
              );
            },
          );
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
            Icons.bookmark_outline,
            size: 64,
            color: AppColors.gold.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada restoran favorit',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap ikon bookmark di halaman detail\nuntuk menambahkan ke favorit',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
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

class _BookmarkCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _BookmarkCard({
    required this.restaurant,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(restaurant.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onRemove(),
      child: RestaurantCard(
        restaurant: restaurant,
        onTap: onTap,
      ),
    );
  }
}
