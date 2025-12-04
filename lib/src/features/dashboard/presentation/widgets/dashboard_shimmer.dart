import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surface,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16).copyWith(top: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 1. Progress Section Shimmer
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _ShimmerCard(height: 130)),
                        const SizedBox(width: 16),
                        Expanded(child: _ShimmerCard(height: 130)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(children: [Expanded(child: _ShimmerCard(height: 130))]),
                  ],
                ),

                const SizedBox(height: 16),

                // 2. Main Content Area Shimmer (Active Quiz / Recent Quizzes)
                const _ShimmerCard(height: 250),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final double height;

  const _ShimmerCard({required this.height});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
          height: height,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 1200.ms,
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        );
  }
}
