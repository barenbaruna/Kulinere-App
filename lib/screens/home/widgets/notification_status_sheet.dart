import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/providers/navigation_provider.dart';
import 'package:kulinere/providers/settings_provider.dart';

/// Bottom sheet displaying notification status and quick actions.
///
/// Shows contextual content based on reminder state:
/// - **Enabled**: Active status, schedule info, test button, settings link
/// - **Disabled**: Info prompt with enable button
///
/// Follows Kulinere Design System with gold accents and PlayfairDisplay headers.
class NotificationStatusSheet extends StatelessWidget {
  const NotificationStatusSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldColor = AppColors.goldVisible(isDark);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3E3E3E) : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Text(
            'Notifikasi',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontFamily: 'PlayfairDisplay',
              fontWeight: FontWeight.bold,
              color: goldColor,
            ),
          ),
          const SizedBox(height: 24),

          // Content based on reminder state
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return settings.dailyReminderEnabled
                  ? _buildEnabledState(context, settings, isDark, goldColor)
                  : _buildDisabledState(context, settings, isDark, goldColor);
            },
          ),
        ],
      ),
    );
  }

  /// Builds UI when daily reminder is enabled.
  Widget _buildEnabledState(
    BuildContext context,
    SettingsProvider settings,
    bool isDark,
    Color goldColor,
  ) {
    return Column(
      children: [
        // Status indicator
        _buildStatusCard(
          isDark: isDark,
          goldColor: goldColor,
          icon: Icons.notifications_active_rounded,
          iconColor: AppColors.success,
          title: 'Pengingat Makan Siang Aktif',
          subtitle: 'Setiap hari pukul 11:00',
        ),
        const SizedBox(height: 16),

        // Test notification button
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () {
              settings.showTestNotification();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifikasi dikirim! Cek notification tray.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.restaurant_menu, size: 18),
            label: const Text('Tes Notifikasi Sekarang'),
            style: FilledButton.styleFrom(
              backgroundColor: goldColor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Settings link
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
            context.read<NavigationProvider>().setIndex(3);
          },
          icon: Icon(Icons.settings_outlined, size: 18, color: goldColor),
          label: Text(
            'Kelola di Pengaturan',
            style: TextStyle(color: goldColor),
          ),
        ),
      ],
    );
  }

  /// Builds UI when daily reminder is disabled.
  Widget _buildDisabledState(
    BuildContext context,
    SettingsProvider settings,
    bool isDark,
    Color goldColor,
  ) {
    return Column(
      children: [
        // Status indicator
        _buildStatusCard(
          isDark: isDark,
          goldColor: goldColor,
          icon: Icons.notifications_off_rounded,
          iconColor: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
          title: 'Pengingat Tidak Aktif',
          subtitle: 'Aktifkan untuk rekomendasi restoran harian pukul 11:00',
        ),
        const SizedBox(height: 16),

        // Enable button
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () async {
              await settings.setDailyReminderEnabled(true);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengingat harian diaktifkan! 🔔'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            icon: const Icon(Icons.notifications_active, size: 18),
            label: const Text('Aktifkan Pengingat'),
            style: FilledButton.styleFrom(
              backgroundColor: goldColor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Reusable status card with icon, title, and subtitle.
  Widget _buildStatusCard({
    required bool isDark,
    required Color goldColor,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
