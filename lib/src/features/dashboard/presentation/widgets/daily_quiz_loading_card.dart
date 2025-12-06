import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DailyQuizLoadingCard extends StatelessWidget {
  const DailyQuizLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.primary.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "DAILY QUIZ" label
                      _ShimmerBlock(width: 80, height: 11, radius: 2),
                      const SizedBox(height: 6),
                      // Title line 1
                      _ShimmerBlock(
                        width: double.infinity,
                        height: 18,
                        radius: 4,
                      ),
                      const SizedBox(height: 4),
                      // Title line 2 (partial)
                      _ShimmerBlock(width: 150, height: 18, radius: 4),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Icon Indicator
                _ShimmerBlock(width: 48, height: 48, radius: 24),
              ],
            ),
            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Questions count
                _ShimmerBlock(width: 90, height: 13, radius: 2),
                // Difficulty • Category
                _ShimmerBlock(width: 120, height: 13, radius: 2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBlock extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _ShimmerBlock({
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(radius),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 1200.ms,
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        );
  }
}
