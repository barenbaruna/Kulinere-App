import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kulinere/core/theme/app_colors.dart';

/// Cached network image with loading and error states.
///
/// Features:
/// - Loading spinner placeholder
/// - Error fallback with restaurant icon
/// - Optional border radius clipping
class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => _buildPlaceholder(isDark),
      errorWidget: (context, url, error) => _buildErrorWidget(isDark),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      width: width,
      height: height,
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold),
      ),
    );
  }

  Widget _buildErrorWidget(bool isDark) {
    return Container(
      width: width,
      height: height,
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Icon(Icons.restaurant, size: 40, color: AppColors.gold),
    );
  }
}
