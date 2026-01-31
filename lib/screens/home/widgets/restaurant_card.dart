import 'package:flutter/material.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/data/models/restaurant.dart';
import 'package:kulinere/widgets/cached_image.dart';

/// Restaurant card widget for list display.
///
/// Features:
/// - Hero animation for image transition
/// - Rating badge with gold accent
/// - City with location icon
class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;
  final String heroTagPrefix;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
    this.heroTagPrefix = 'home',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildImage(),
                const SizedBox(width: 14),
                Expanded(child: _buildContent(isDark)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Hero(
      tag: '$heroTagPrefix-restaurant-image-${restaurant.id}',
      child: CachedImage(
        imageUrl: restaurant.mediumImageUrl,
        width: 110,
        height: 85,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          restaurant.name,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        _buildCityRow(isDark),
        const SizedBox(height: 10),
        _buildRatingBadge(isDark),
      ],
    );
  }

  Widget _buildCityRow(bool isDark) {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 14,
          color: AppColors.goldVisible(isDark),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            restaurant.city,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF2A2620)
            : AppColors.gold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark
              ? const Color(0xFF3A3630)
              : AppColors.gold.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 14, color: AppColors.goldVisible(isDark)),
          const SizedBox(width: 4),
          Text(
            restaurant.rating.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
