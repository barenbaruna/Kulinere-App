import 'package:flutter/material.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/data/models/customer_review.dart';

class ReviewSection extends StatelessWidget {
  final List<CustomerReview> reviews;

  const ReviewSection({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.reviews, size: 20, color: AppColors.gold),
            const SizedBox(width: 8),
            Text(
              'Ulasan (${reviews.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (reviews.isEmpty)
          Text(
            'Belum ada ulasan',
            style: Theme.of(context).textTheme.bodyMedium,
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final review = reviews[index];
              return _ReviewCard(review: review);
            },
          ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final CustomerReview review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.gold.withOpacity(0.2),
                  child: Text(
                    review.name.isNotEmpty ? review.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: AppColors.goldDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        review.date,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.review,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
