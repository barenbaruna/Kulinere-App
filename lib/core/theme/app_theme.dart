import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// App theme configuration with Material 3 design.
///
/// Provides [lightTheme] and [darkTheme] with consistent styling:
/// - Color scheme using gold brand colors
/// - Typography with PlayfairDisplay and Inter fonts
/// - Consistent card, button, and chip styling
class AppTheme {
  /// Light theme configuration.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.goldDark,
        onPrimary: AppColors.lightTextPrimary,
        secondary: AppColors.gold,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      cardColor: AppColors.lightSurface,
      dividerColor: AppColors.lightDivider,
      textTheme: AppTypography.textTheme(
        AppColors.lightTextPrimary,
        AppColors.lightTextSecondary,
      ),
      appBarTheme: _buildAppBarTheme(isDark: false),
      cardTheme: _buildCardTheme(AppColors.lightSurface),
      filledButtonTheme: _buildFilledButtonTheme(
        backgroundColor: AppColors.goldDark,
        foregroundColor: AppColors.lightTextPrimary,
      ),
      chipTheme: _buildChipTheme(
        backgroundColor: AppColors.lightSurface,
        labelColor: AppColors.lightTextPrimary,
      ),
    );
  }

  /// Dark theme configuration.
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.gold,
        onPrimary: AppColors.lightTextPrimary,
        secondary: AppColors.goldDark,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkSurface,
      dividerColor: AppColors.darkDivider,
      textTheme: AppTypography.textTheme(
        AppColors.darkTextPrimary,
        AppColors.darkTextSecondary,
      ),
      appBarTheme: _buildAppBarTheme(isDark: true),
      cardTheme: _buildCardTheme(AppColors.darkSurface),
      filledButtonTheme: _buildFilledButtonTheme(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.lightTextPrimary,
      ),
      chipTheme: _buildChipTheme(
        backgroundColor: AppColors.darkSurface,
        labelColor: AppColors.darkTextPrimary,
      ),
    );
  }

  static AppBarTheme _buildAppBarTheme({required bool isDark}) {
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final fgColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    return AppBarTheme(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: bgColor,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: fgColor,
      ),
    );
  }

  static CardThemeData _buildCardTheme(Color color) {
    return CardThemeData(
      color: color,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  static FilledButtonThemeData _buildFilledButtonTheme({
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  static ChipThemeData _buildChipTheme({
    required Color backgroundColor,
    required Color labelColor,
  }) {
    return ChipThemeData(
      backgroundColor: backgroundColor,
      labelStyle: GoogleFonts.inter(fontSize: 14, color: labelColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.gold.withOpacity(0.5)),
      ),
    );
  }
}
