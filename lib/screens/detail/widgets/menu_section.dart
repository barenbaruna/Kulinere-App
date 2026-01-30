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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.gold),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) => Chip(
            label: Text(item.name),
            avatar: Icon(
              icon == Icons.restaurant_menu ? Icons.lunch_dining : Icons.local_cafe,
              size: 16,
              color: AppColors.gold,
            ),
          )).toList(),
        ),
      ],
    );
  }
}
