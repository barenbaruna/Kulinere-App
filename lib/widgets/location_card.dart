import 'package:flutter/material.dart';
import 'package:kulinere/core/theme/app_colors.dart';

/// Location card widget untuk menampilkan kota dalam horizontal scroll.
///
/// Mengikuti design system:
/// - Border radius: 12dp
/// - Colors: goldVisible, surface
/// - Min touch target: 48dp
class LocationCard extends StatelessWidget {
  final String city;
  final int restaurantCount;
  final bool isSelected;
  final VoidCallback onTap;

  const LocationCard({
    super.key,
    required this.city,
    required this.restaurantCount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = AppColors.goldVisible(isDark);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Color.fromRGBO(
                  goldColor.red,
                  goldColor.green,
                  goldColor.blue,
                  0.15,
                )
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? goldColor
                : (isDark ? AppColors.darkDivider : AppColors.lightDivider),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_city_outlined,
              size: 24,
              color: isSelected
                  ? goldColor
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              city,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? goldColor
                    : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '$restaurantCount resto',
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
