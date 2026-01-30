import 'package:flutter/material.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/data/models/customer_review.dart';

class ReviewSection extends StatefulWidget {
  final List<CustomerReview> reviews;
  final int initialDisplayCount;

  const ReviewSection({
    super.key,
    required this.reviews,
    this.initialDisplayCount = 3,
  });

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = AppColors.goldVisible(isDark);

    // Determine how many reviews to show
    final displayedReviews = _showAll
        ? widget.reviews
        : widget.reviews.take(widget.initialDisplayCount).toList();
    final hasMore = widget.reviews.length > widget.initialDisplayCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with count badge
        Row(
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
                '${widget.reviews.length}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: goldColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.reviews.isEmpty)
          _buildEmptyState(context, isDark)
        else ...[
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayedReviews.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final review = displayedReviews[index];
              return _ReviewCard(review: review);
            },
          ),
          // Show "See All" button if there are more reviews
          if (hasMore && !_showAll) ...[
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () => setState(() => _showAll = true),
                icon: Icon(Icons.expand_more, color: goldColor),
                label: Text(
                  'Lihat Semua (${widget.reviews.length - widget.initialDisplayCount} lagi)',
                  style: TextStyle(
                    color: goldColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  backgroundColor: goldColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
          // Show "Show Less" button if expanded
          if (_showAll && hasMore) ...[
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () => setState(() => _showAll = false),
                icon: Icon(Icons.expand_less, color: goldColor),
                label: Text(
                  'Tampilkan Lebih Sedikit',
                  style: TextStyle(
                    color: goldColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  backgroundColor: goldColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ],
      ],
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
          // Header with avatar and info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with gold ring
                Container(
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
                    backgroundColor: isDark
                        ? AppColors.darkBackground
                        : Colors.white,
                    child: Text(
                      review.name.isNotEmpty
                          ? review.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: goldColor,
                        fontFamily: 'PlayfairDisplay',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Name and date
                Expanded(
                  child: Column(
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
                  ),
                ),
              ],
            ),
          ),
          // Review text with speech bubble style
          Container(
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
                Icon(
                  Icons.format_quote,
                  size: 18,
                  color: goldColor.withOpacity(0.6),
                ),
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
          ),
        ],
      ),
    );
  }
}
