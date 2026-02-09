import 'package:flutter/material.dart';

/// Reusable error widget with retry button.
///
/// Displays error icon, message, and retry action.
class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Terjadi Kesalahan',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getFriendlyMessage(message),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  String _getFriendlyMessage(String error) {
    if (error.contains('SocketException') ||
        error.contains('Failed host lookup') ||
        error.contains('Connection refused')) {
      return 'Tidak ada koneksi internet.\nPeriksa jaringan Anda.';
    }
    if (error.contains('TimeoutException') ||
        error.contains('Connection timed out')) {
      return 'Koneksi waktu habis.\nSilakan coba lagi.';
    }
    if (error.contains('404')) {
      return 'Data tidak ditemukan.';
    }
    if (error.contains('500') ||
        error.contains('502') ||
        error.contains('503')) {
      return 'Terjadi gangguan pada server.\nCobalah beberapa saat lagi.';
    }
    return error;
  }
}
