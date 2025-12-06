import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Section A: Stats
                const Row(
                  children: [
                    Expanded(child: _StatTileShimmer()),
                    SizedBox(width: 16),
                    Expanded(child: _StatTileShimmer()),
                  ],
                ),

                const SizedBox(height: 24),

                // Section B: Active Quiz
                const _SectionTitleShimmer(),
                const SizedBox(height: 12),
                const _ActiveQuizHeroCardShimmer(),
                const SizedBox(height: 24),

                // Section C: Recent History
                const _SectionTitleShimmer(),
                const SizedBox(height: 12),
                const _RecentQuizzesContainerShimmer(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTileShimmer extends StatelessWidget {
  const _StatTileShimmer();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerBlock(width: 40, height: 40, radius: 20),
          const SizedBox(height: 16),
          _ShimmerBlock(width: 60, height: 28, radius: 4),
          const SizedBox(height: 6),
          _ShimmerBlock(width: 80, height: 13, radius: 4),
        ],
      ),
    );
  }
}

class _SectionTitleShimmer extends StatelessWidget {
  const _SectionTitleShimmer();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _ShimmerBlock(width: 18, height: 18, radius: 4),
        SizedBox(width: 8),
        _ShimmerBlock(width: 120, height: 16, radius: 4),
      ],
    );
  }
}

class _ActiveQuizHeroCardShimmer extends StatelessWidget {
  const _ActiveQuizHeroCardShimmer();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.05)),
      ),
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
                    _ShimmerBlock(width: 80, height: 11, radius: 2),
                    const SizedBox(height: 6),
                    _ShimmerBlock(
                      width: double.infinity,
                      height: 18,
                      radius: 4,
                    ),
                    const SizedBox(height: 4),
                    _ShimmerBlock(width: 150, height: 18, radius: 4),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _ShimmerBlock(width: 48, height: 48, radius: 24),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ShimmerBlock(width: 100, height: 13, radius: 2),
              _ShimmerBlock(width: 100, height: 13, radius: 2),
            ],
          ),
          const SizedBox(height: 10),
          _ShimmerBlock(width: double.infinity, height: 6, radius: 4),
        ],
      ),
    );
  }
}

class _RecentQuizzesContainerShimmer extends StatelessWidget {
  const _RecentQuizzesContainerShimmer();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: List.generate(3, (index) {
          final isLast = index == 2;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    _ShimmerBlock(width: 36, height: 36, radius: 10),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ShimmerBlock(width: 120, height: 14, radius: 4),
                          const SizedBox(height: 4),
                          _ShimmerBlock(width: 80, height: 12, radius: 4),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ShimmerBlock(width: 40, height: 24, radius: 12),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 68,
                  endIndent: 16,
                  color: colorScheme.outline.withValues(alpha: 0.1),
                ),
            ],
          );
        }),
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
