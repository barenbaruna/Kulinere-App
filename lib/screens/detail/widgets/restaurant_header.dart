import 'package:flutter/material.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/data/models/restaurant_detail.dart';
import 'package:kulinere/providers/bookmark_provider.dart';
import 'package:kulinere/widgets/cached_image.dart';
import 'package:provider/provider.dart';

class RestaurantHeader extends StatelessWidget {
  final RestaurantDetail restaurant;
  final String heroTagPrefix;

  const RestaurantHeader({
    super.key,
    required this.restaurant,
    this.heroTagPrefix = 'home',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: '$heroTagPrefix-restaurant-image-${restaurant.id}',
          child: CachedImage(
            imageUrl: restaurant.largeImageUrl,
            width: double.infinity,
            height: 250,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 18, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Text(
                      restaurant.rating.toString(),
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: AppColors.gold),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.location_on, size: 16, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(
                      restaurant.city,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 8,
          child: CircleAvatar(
            backgroundColor: Colors.black38,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 8,
          child: Consumer<BookmarkProvider>(
            builder: (context, bookmarkProvider, child) {
              final isBookmarked = bookmarkProvider.isBookmarked(restaurant.id);
              return CircleAvatar(
                backgroundColor: Colors.black38,
                child: IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? AppColors.gold : Colors.white,
                  ),
                  onPressed: () {
                    bookmarkProvider.toggleBookmark(restaurant.id);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
