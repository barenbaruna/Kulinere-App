import 'package:flutter/material.dart';
import 'package:kulinere/core/theme/app_colors.dart';

/// Reusable profile avatar widget used in HomeScreen and ProfileScreen.
///
/// Follows DRY principle - single source of truth for avatar styling.
/// Design system compliant: gold ring, surface background.
class ProfileAvatar extends StatelessWidget {
  /// Size of the avatar (diameter)
  final double size;

  /// Optional callback when avatar is tapped
  final VoidCallback? onTap;

  /// Whether to show the profile image or just initials
  final bool showImage;

  const ProfileAvatar({
    super.key,
    this.size = 36,
    this.onTap,
    this.showImage = true,
  });

  // Profile image path - single source of truth
  static const String profileImagePath = 'images/profile_photo.jpg';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = AppColors.goldVisible(isDark);

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: goldColor, width: size > 40 ? 3 : 2),
      ),
      child: ClipOval(
        child: showImage
            ? Image.asset(
                profileImagePath,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to initials if image not found
                  return _buildInitialsAvatar(context, isDark, goldColor);
                },
              )
            : _buildInitialsAvatar(context, isDark, goldColor),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: avatar);
    }
    return avatar;
  }

  Widget _buildInitialsAvatar(
    BuildContext context,
    bool isDark,
    Color goldColor,
  ) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Text(
        'B', // Default initial
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
          color: goldColor,
        ),
      ),
    );
  }
}
