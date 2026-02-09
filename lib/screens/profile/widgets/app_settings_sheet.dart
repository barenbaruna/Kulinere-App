import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/providers/settings_provider.dart';

/// Modal Bottom Sheet for App Settings (Theme & Notifications).
///
/// Designed to be called from the Profile Screen.
/// Follows Kulinere Design System (Gold/Dark theme).
class AppSettingsSheet extends StatelessWidget {
  const AppSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldColor = AppColors.goldVisible(isDark);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle Bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF3E3E3E)
                    : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text(
            'Pengaturan Aplikasi',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontFamily: 'PlayfairDisplay',
              fontWeight: FontWeight.bold,
              color: goldColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return Column(
                children: [
                  _buildThemeSection(context, settings, isDark, goldColor),
                  const SizedBox(height: 24),
                  _buildNotificationSection(
                    context,
                    settings,
                    isDark,
                    goldColor,
                  ),
                  if (settings.dailyReminderEnabled) ...[
                    const SizedBox(height: 16),
                    _buildTestNotificationButton(
                      context,
                      settings,
                      isDark,
                      goldColor,
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSection(
    BuildContext context,
    SettingsProvider settings,
    bool isDark,
    Color goldColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tampilan',
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildThemeOption(
              context,
              settings,
              ThemeMode.light,
              Icons.wb_sunny_outlined,
              'Terang',
              isDark,
              goldColor,
            ),
            const SizedBox(width: 12),
            _buildThemeOption(
              context,
              settings,
              ThemeMode.dark,
              Icons.nightlight_round,
              'Gelap',
              isDark,
              goldColor,
            ),
            const SizedBox(width: 12),
            _buildThemeOption(
              context,
              settings,
              ThemeMode.system,
              Icons.settings_system_daydream,
              'Sistem',
              isDark,
              goldColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    SettingsProvider settings,
    ThemeMode mode,
    IconData icon,
    String label,
    bool isDark,
    Color goldColor,
  ) {
    final isSelected = settings.themeMode == mode;
    final borderColor = isSelected
        ? goldColor
        : (isDark ? AppColors.darkDivider : AppColors.lightDivider);
    final bgColor = isSelected
        ? goldColor.withOpacity(0.1)
        : Colors.transparent;

    return Expanded(
      child: InkWell(
        onTap: () => settings.setThemeMode(mode),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? goldColor
                    : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? goldColor
                      : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationSection(
    BuildContext context,
    SettingsProvider settings,
    bool isDark,
    Color goldColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          'Pengingat Harian',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        subtitle: Text(
          'Rekomendasi makan siang pukul 11:00',
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        secondary: Icon(
          Icons.notifications_active_outlined,
          color: settings.dailyReminderEnabled
              ? goldColor
              : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
        ),
        activeColor: goldColor,
        value: settings.dailyReminderEnabled,
        onChanged: (value) => settings.setDailyReminderEnabled(value),
      ),
    );
  }

  Widget _buildTestNotificationButton(
    BuildContext context,
    SettingsProvider settings,
    bool isDark,
    Color goldColor,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => settings.showTestNotification(),
        icon: const Icon(Icons.notifications_active),
        label: const Text('Tes Notifikasi Sekarang'),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: goldColor),
          foregroundColor: goldColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
