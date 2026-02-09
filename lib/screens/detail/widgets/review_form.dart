import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/providers/restaurant_detail_provider.dart';

/// Review submission form with validation and loading state.
///
/// Features:
/// - Name and review text fields with validation
/// - Loading indicator during submission
/// - Success/error snackbar feedback
class ReviewForm extends StatefulWidget {
  final String restaurantId;
  final VoidCallback? onSubmitted;

  const ReviewForm({super.key, required this.restaurantId, this.onSubmitted});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<RestaurantDetailProvider>();

    try {
      await provider.addReview(
        name: _nameController.text.trim(),
        review: _reviewController.text.trim(),
      );

      _nameController.clear();
      _reviewController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Review berhasil dikirim!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        provider.resetReviewForm();
        widget.onSubmitted?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.submissionError.isNotEmpty
                  ? _getFriendlyErrorMessage(provider.submissionError)
                  : 'Gagal mengirim review',
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = AppColors.goldVisible(isDark);
    final dividerColor = isDark
        ? AppColors.darkDivider
        : AppColors.lightDivider;
    final fillColor = isDark ? AppColors.darkBackground : Colors.white;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dividerColor),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, goldColor),
            const SizedBox(height: 24),
            _buildNameField(isDark, goldColor, dividerColor, fillColor),
            const SizedBox(height: 16),
            _buildReviewField(isDark, goldColor, dividerColor, fillColor),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color goldColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: goldColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.edit_note_rounded, color: goldColor, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tulis Review',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Bagikan pengalaman Anda',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNameField(
    bool isDark,
    Color goldColor,
    Color dividerColor,
    Color fillColor,
  ) {
    return TextFormField(
      controller: _nameController,
      decoration: _inputDecoration(
        labelText: 'Nama Anda',
        prefixIcon: Icons.person_outline_rounded,
        isDark: isDark,
        goldColor: goldColor,
        dividerColor: dividerColor,
        fillColor: fillColor,
      ),
      textInputAction: TextInputAction.next,
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? 'Nama wajib diisi' : null,
    );
  }

  Widget _buildReviewField(
    bool isDark,
    Color goldColor,
    Color dividerColor,
    Color fillColor,
  ) {
    return TextFormField(
      controller: _reviewController,
      decoration: InputDecoration(
        hintText: 'Ceritakan pengalaman Anda di restoran ini...',
        hintStyle: TextStyle(
          color:
              (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary)
                  .withOpacity(0.6),
        ),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: goldColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      maxLines: 4,
      textInputAction: TextInputAction.done,
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? 'Review wajib diisi' : null,
    );
  }

  InputDecoration _inputDecoration({
    required String labelText,
    required IconData prefixIcon,
    required bool isDark,
    required Color goldColor,
    required Color dividerColor,
    required Color fillColor,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
      ),
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: goldColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      prefixIcon: Icon(prefixIcon, color: goldColor),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildSubmitButton() {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, provider, child) {
        final isSubmitting =
            provider.submissionState == ReviewSubmissionState.submitting;

        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: isSubmitting ? null : _submitReview,
            icon: isSubmitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send_rounded, size: 18),
            label: Text(isSubmitting ? 'Mengirim...' : 'Kirim Review'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getFriendlyErrorMessage(String error) {
    if (error.contains('SocketException') ||
        error.contains('Failed host lookup') ||
        error.contains('Connection refused')) {
      return 'Tidak ada koneksi internet. Cek sinyal kamu ya!';
    }
    if (error.contains('TimeoutException') ||
        error.contains('Connection timed out')) {
      return 'Yah, waktu habis. Coba kirim lagi ya.';
    }
    return error;
  }
}
