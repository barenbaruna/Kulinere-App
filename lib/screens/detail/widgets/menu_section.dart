import 'package:flutter/material.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/data/models/menu_item.dart';

class MenuSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<MenuItem> items;

  const MenuSection({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = AppColors.goldVisible(isDark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header - Fixed truncation
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: goldColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: goldColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: goldColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${items.length} item',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: goldColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Horizontal Scroll Menu Items
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _MenuItemCard(
                item: items[index],
                icon: icon,
                isDark: isDark,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final IconData icon;
  final bool isDark;

  const _MenuItemCard({
    required this.item,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Choose icon based on menu type
    final IconData itemIcon = icon == Icons.restaurant_menu
        ? Icons.lunch_dining
        : Icons.local_cafe;
    final goldColor = AppColors.goldVisible(isDark);

    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: goldColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(itemIcon, size: 28, color: goldColor),
          ),
          const SizedBox(height: 10),
          // Item Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              item.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
