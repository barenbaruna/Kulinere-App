import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/screens/profile/widgets/app_settings_sheet.dart';
import 'package:kulinere/widgets/profile_avatar.dart';

/// Unified Profile Screen with "Menu-Based" Design.
///
/// Highlights User Identity first, then provides clean access to Settings & Info via menu.
/// Avoids clutter by using a Modal Bottom Sheet for settings.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String _name = 'Baren Baruna Harahap';
  static const String _role = 'Junior Mobile & AI Engineer';
  static const String _email = 'barenbarunaharahap@gmail.com';

  // Developer Info (Hidden by default, shown in "Tentang" or separate view if needed)
  static const String _bio =
      'Mobile Development enthusiast with AI/ML background. '
      'Building smart, user-centric apps with Flutter & Swift.';

  static const List<String> _skills = [
    'Flutter',
    'Dart',
    'AI/ML',
    'Swift',
    'UI/UX',
  ];

  static const Map<String, String> _links = {
    'GitHub': 'https://github.com/barenbaruna',
    'LinkedIn': 'https://www.linkedin.com/in/barenbarunaharahap',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil & Akun',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.goldVisible(isDark),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. Identity Header (Premium Card)
            _buildIdentityCard(context, theme, isDark),
            const SizedBox(height: 32),

            // 2. Action Menu
            _buildSectionHeader(theme, 'Menu Aplikasi', isDark),
            const SizedBox(height: 12),
            _buildMenuContainer(
              isDark,
              children: [
                _buildMenuOption(
                  context,
                  title: 'Pengaturan Aplikasi',
                  subtitle: 'Tema & Notifikasi',
                  icon: Icons.tune,
                  isDark: isDark,
                  onTap: () => _showSettingsSheet(context),
                ),
                _buildDivider(isDark),
                _buildMenuOption(
                  context,
                  title: 'Tentang Developer',
                  subtitle: 'Bio, Skills & Kontak',
                  icon: Icons.person_outline,
                  isDark: isDark,
                  onTap: () => _showDeveloperInfo(context, theme, isDark),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // 3. Main Action
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur Unduh CV segera hadir!'),
                    ),
                  );
                },
                icon: const Icon(Icons.download_rounded),
                label: const Text('Unduh Resume / CV'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.goldVisible(isDark)),
                  foregroundColor: AppColors.goldVisible(isDark),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 48),
            Text(
              'Kulinere v2.0 • © ${DateTime.now().year} Baren',
              style: theme.textTheme.bodySmall?.copyWith(
                color:
                    (theme.textTheme.bodySmall?.color ??
                            (theme.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black))
                        .withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentityCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.goldVisible(isDark).withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.goldVisible(isDark),
                width: 2,
              ),
            ),
            child: const ProfileAvatar(size: 100),
          ),
          const SizedBox(height: 16),
          Text(
            _name,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontFamily: 'PlayfairDisplay',
              fontWeight: FontWeight.bold,
              color: AppColors.goldVisible(isDark),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _role,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.goldVisible(isDark).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.email_outlined,
                  size: 14,
                  color: AppColors.goldVisible(isDark),
                ),
                const SizedBox(width: 8),
                Text(
                  _email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.goldVisible(isDark),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _buildMenuContainer(bool isDark, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.goldVisible(isDark), size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      indent: 70,
      color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AppSettingsSheet(),
    );
  }

  void _showDeveloperInfo(BuildContext context, ThemeData theme, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                'Tentang Developer',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontFamily: 'PlayfairDisplay',
                  fontWeight: FontWeight.bold,
                  color: AppColors.goldVisible(isDark),
                ),
              ),
              const SizedBox(height: 24),
              Text('BIO', style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              Text(_bio, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 24),

              Text('SKILLS', style: theme.textTheme.labelLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _skills
                    .map(
                      (s) => Chip(
                        label: Text(s),
                        backgroundColor: AppColors.goldVisible(
                          isDark,
                        ).withOpacity(0.1),
                        side: BorderSide.none,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),

              Text('CONTACT', style: theme.textTheme.labelLarge),
              const SizedBox(height: 12),
              Column(
                children: _links.entries
                    .map(
                      (e) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.link,
                          color: AppColors.goldVisible(isDark),
                        ),
                        title: Text(e.key),
                        subtitle: Text(
                          e.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: e.value));
                          Navigator.pop(context); // Close sheet immediately
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Link disalin!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
