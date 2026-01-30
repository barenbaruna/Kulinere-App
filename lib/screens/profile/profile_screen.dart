import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kulinere/core/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String _name = 'Baren Baruna Harahap';
  static const String _role = 'Junior Mobile & AI Engineer';
  static const String _location = 'Indonesia';
  static const String _bio =
      'Curious tentang Mobile Development dengan background AI, ML, dan Deep Learning. '
      'Ikut IDCamp 2025 untuk mendalami integrasi AI di mobile app. '
      'Suka ngulik open-source project, antusias dengan mobile app, machine learning, dan computer vision.';

  static const Map<String, String> _links = {
    'GitHub': 'https://github.com/barenbaruna',
    'LinkedIn': 'https://www.linkedin.com/in/barenbarunaharahap',
    'Email': 'mailto:barenbarunaharahap@gmail.com',
    'Scholar': 'https://scholar.google.com/citations?user=4vwtBgoAAAAJ&hl=en',
  };

  static const List<String> _skills = [
    'Flutter',
    'Dart',
    'Machine Learning',
    'Computer Vision',
    'Swift',
    'UI/UX',
  ];

  void _showLinkDialog(BuildContext context, String title, String url) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SelectableText(url),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(milliseconds: 800),
                  content: Text('Link disalin ke clipboard'),
                ),
              );
            },
            child: Text(
              'Salin',
              style: TextStyle(
                color: AppColors.goldVisible(
                  Theme.of(context).brightness == Brightness.dark,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  IconData _getIconForLink(String key) {
    switch (key) {
      case 'GitHub':
        return Icons.code;
      case 'LinkedIn':
        return Icons.business;
      case 'Email':
        return Icons.email;
      case 'Scholar':
        return Icons.school;
      default:
        return Icons.link;
    }
  }

  Widget _buildContactTile(BuildContext context, String title, String url) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = AppColors.goldVisible(isDark);
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: goldColor.withOpacity(0.15),
        child: Icon(_getIconForLink(title), color: goldColor),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(
        url,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: IconButton(
        icon: Icon(Icons.open_in_new, color: goldColor),
        onPressed: () => _showLinkDialog(context, title, url),
        tooltip: 'Lihat/Salin link',
      ),
      onTap: () => _showLinkDialog(context, title, url),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Header - matching Home & Search style
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profil',
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.goldVisible(isDark),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(milliseconds: 800),
                          content: Text('Fungsi share dalam pengembangan'),
                        ),
                      );
                    },
                    tooltip: 'Bagikan Profil',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Header with avatar and info
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: AppColors.goldVisible(
                      isDark,
                    ).withOpacity(0.2),
                    backgroundImage: const AssetImage('images/profile_photo.jpg'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PlayfairDisplay',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(_role, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            Chip(
                              label: Text(_location),
                              backgroundColor: AppColors.goldVisible(
                                isDark,
                              ).withOpacity(0.15),
                              side: BorderSide.none,
                            ),
                            Chip(
                              label: const Text('Open-source'),
                              backgroundColor: AppColors.goldVisible(
                                isDark,
                              ).withOpacity(0.15),
                              side: BorderSide.none,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Bio Card
              Card(
                elevation: isDark ? 0 : 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isDark ? AppColors.darkDivider : Colors.transparent,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _bio,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Skills Section
              Text(
                'Keahlian',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.goldVisible(isDark),
                  fontFamily: 'PlayfairDisplay',
                ),
              ),
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
                        ).withOpacity(0.15),
                        side: BorderSide.none,
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 24),

              // Contact Section
              Text(
                'Kontak',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.goldVisible(isDark),
                  fontFamily: 'PlayfairDisplay',
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: isDark ? 0 : 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isDark ? AppColors.darkDivider : Colors.transparent,
                  ),
                ),
                child: Column(
                  children: _links.entries
                      .map((e) => _buildContactTile(context, e.key, e.value))
                      .toList(),
                ),
              ),

              const SizedBox(height: 24),

              // Download CV Button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(milliseconds: 800),
                        content: Text('Unduh CV dalam pengembangan'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.file_download),
                  label: const Text('Unduh CV'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Footer
              Center(
                child: Text(
                  '© ${DateTime.now().year} Baren. All Rights Reserved.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
