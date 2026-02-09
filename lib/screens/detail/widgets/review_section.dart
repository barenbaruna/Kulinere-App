import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/data/models/customer_review.dart';
import 'package:kulinere/providers/restaurant_detail_provider.dart';

/// Customer review section with expandable list.
///
/// Features:
/// - Shows initial 3 reviews with "See All" button
/// - Empty state when no reviews exist
/// - Gold-accented styling per design system
class ReviewSection extends StatelessWidget {
  final List<CustomerReview> reviews;
  final int initialDisplayCount;

  const ReviewSection({
    super.key,
    required this.reviews,
    this.initialDisplayCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = AppColors.goldVisible(isDark);

    return Consumer<RestaurantDetailProvider>(
      builder: (context, provider, child) {
        final showAll = provider.showAllReviews;

        final displayedReviews = showAll
            ? reviews
            : reviews.take(initialDisplayCount).toList();
        final hasMore = reviews.length > initialDisplayCount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, goldColor),
            const SizedBox(height: 16),
            if (reviews.isEmpty)
              _buildEmptyState(context, isDark)
            else ...[
              _buildReviewList(displayedReviews),
              if (hasMore) _buildToggleButton(context, provider, goldColor),
            ],
          ],
        );
      },
    );
  }

  Widget _buildHeader(bool isDark, Color goldColor) {
    return Row(
      children: [
        Icon(Icons.rate_review_outlined, size: 22, color: goldColor),
        const SizedBox(width: 8),
        Text(
          'Ulasan',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: goldColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${reviews.length}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: goldColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewList(List<CustomerReview> reviews) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _ReviewCard(review: reviews[index]),
    );
  }

  Widget _buildToggleButton(
    BuildContext context,
    RestaurantDetailProvider provider,
    Color goldColor,
  ) {
    final isExpanded = provider.showAllReviews;
    final remaining = reviews.length - initialDisplayCount;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Center(
        child: TextButton.icon(
          onPressed: () => provider.toggleShowAllReviews(),
          icon: Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: goldColor,
          ),
          label: Text(
            isExpanded
                ? 'Tampilkan Lebih Sedikit'
                : 'Lihat Semua ($remaining lagi)',
            style: TextStyle(color: goldColor, fontWeight: FontWeight.w500),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            backgroundColor: goldColor.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: AppColors.goldVisible(isDark).withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada ulasan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Jadilah yang pertama memberi ulasan!',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// Individual review card with avatar and quote styling.
class _ReviewCard extends StatelessWidget {
  final CustomerReview review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = AppColors.goldVisible(isDark);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDark, goldColor),
          _buildReviewText(isDark, goldColor),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color goldColor) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(isDark, goldColor),
          const SizedBox(width: 12),
          Expanded(child: _buildNameAndDate(isDark)),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isDark, Color goldColor) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [goldColor, goldColor.withOpacity(0.5)],
        ),
      ),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
        child: Text(
          review.name.isNotEmpty ? review.name[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: goldColor,
            fontFamily: 'PlayfairDisplay',
          ),
        ),
      ),
    );
  }

  Widget _buildNameAndDate(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          review.name,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.schedule_outlined,
              size: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              review.date,
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewText(bool isDark, Color goldColor) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : goldColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.format_quote, size: 18, color: goldColor.withOpacity(0.6)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              review.review,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
