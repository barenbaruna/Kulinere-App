import 'package:flutter/material.dart';
import 'package:kulinere/core/theme/app_colors.dart';

/// Reusable profile avatar widget with gold ring styling.
///
/// Features:
/// - Configurable size with proportional border width
/// - Optional tap callback for navigation
/// - Fallback to initials when image unavailable
/// - Design system compliant (gold ring, surface background)
class ProfileAvatar extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;
  final bool showImage;

  static const String _profileImagePath = 'images/profile_photo.jpg';

  const ProfileAvatar({
    super.key,
    this.size = 36,
    this.onTap,
    this.showImage = true,
  });

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
            ? _buildImageAvatar(isDark, goldColor)
            : _buildInitialsAvatar(isDark, goldColor),
      ),
    );

    return onTap != null
        ? GestureDetector(onTap: onTap, child: avatar)
        : avatar;
  }

  Widget _buildImageAvatar(bool isDark, Color goldColor) {
    return Image.asset(
      _profileImagePath,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          _buildInitialsAvatar(isDark, goldColor),
    );
  }

  Widget _buildInitialsAvatar(bool isDark, Color goldColor) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Text(
        'B',
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
          color: goldColor,
        ),
      ),
    );
  }
}
