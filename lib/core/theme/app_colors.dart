import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color gold = Color(0xFFf3d396);
  static const Color goldDark = Color(0xFFC9A86C);

  // Semantic Gold - Use these for proper visibility
  /// Gold color that has good contrast based on theme
  static Color goldVisible(bool isDark) => isDark ? gold : goldDark;

  // Light Mode
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFDF8F0);
  static const Color lightTextPrimary = Color(0xFF1F1F1F);
  static const Color lightTextSecondary = Color(0xFF5C5C5C);
  static const Color lightDivider = Color(0xFFE0E0E0);

  // Dark Mode
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1A14);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFA0A0A0);
  static const Color darkDivider = Color(0xFF2C2C2C);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFB8C00);
  static const Color info = Color(0xFF2196F3);
}
