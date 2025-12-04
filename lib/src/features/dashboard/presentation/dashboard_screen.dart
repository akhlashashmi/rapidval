import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:rapidval/src/features/quiz/domain/user_answer.dart';

import '../../quiz/data/quiz_repository.dart';

import '../../quiz/presentation/quiz_state.dart';
import '../../quiz/presentation/quiz_controller.dart';
import 'dashboard_stats_provider.dart';
import 'widgets/dashboard_shimmer.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final recentQuizzesAsync = ref.watch(recentQuizResultsProvider);
    final activeQuizProgressAsync = ref.watch(activeQuizProgressProvider);
    final statsAsync = ref.watch(dashboardStatsProvider);

    // Show shimmer if any of the data is not yet available
    if (!statsAsync.hasValue ||
        !activeQuizProgressAsync.hasValue ||
        !recentQuizzesAsync.hasValue) {
      return const DashboardShimmer();
    }

    // Once we have data, we can safely unwrap it
    // We use maybeWhen or just value! since we checked hasValue
    final stats = statsAsync.value!;
    final activeProgress = activeQuizProgressAsync.value;
    final recentQuizzes = recentQuizzesAsync.value ?? [];

    return Container(
      color: colorScheme.surface,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16).copyWith(top: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 1. Progress Section
                _ProgressSection(stats: stats),

                const SizedBox(height: 16),

                // 2. Main Content Area (Active Quiz OR Recent Quizzes)
                if (activeProgress != null)
                  _ActiveQuizCard(state: activeProgress.$1)
                else
                  _RecentQuizzesList(results: recentQuizzes.take(3).toList()),

                const SizedBox(height: 80), // Bottom padding
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// WIDGETS

class _ActiveQuizCard extends ConsumerWidget {
  final QuizState state;

  const _ActiveQuizCard({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress =
        (state.currentQuestionIndex + 1) / state.quiz.questions.length;
    final percentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Continue Learning',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.quiz.title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            state.quiz.category,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.help_outline_rounded,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Question ${state.currentQuestionIndex + 1} of ${state.quiz.questions.length}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.timer_outlined,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                '~${(state.timeLeft / 60).ceil()} min left',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/create-quiz'),
                  icon: const Icon(Icons.add),
                  label: const Text('New Quiz'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: colorScheme.primary),
                    foregroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () async {
                    await ref
                        .read(quizControllerProvider.notifier)
                        .resumeQuiz();
                    if (context.mounted) context.go('/quiz');
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Resume'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }
}

class _RecentQuizzesList extends StatelessWidget {
  final List<QuizResult> results;

  const _RecentQuizzesList({required this.results});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Quizzes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          if (results.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  "No recent quizzes yet.",
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final result = results[index];
                return _QuizHistoryItem(result: result);
              },
            ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }
}

class _QuizHistoryItem extends StatelessWidget {
  final QuizResult result;

  const _QuizHistoryItem({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final iconData = _getCategoryIcon(result.quiz.category);
    final iconColor = _getCategoryColor(result.quiz.category);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.quiz.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(iconData, size: 14, color: iconColor),
                  const SizedBox(width: 4),
                  Text(
                    result.quiz.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _getScoreColor(result.percentage).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.emoji_events,
                size: 12,
                color: _getScoreColor(result.percentage),
              ),
              const SizedBox(width: 4),
              Text(
                '${result.percentage.toInt()}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: _getScoreColor(result.percentage),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return const Color(0xFF22C55E); // Green
    if (percentage >= 60) return const Color(0xFFF59E0B); // Orange
    return const Color(0xFFEF4444); // Red
  }
}

class _ProgressSection extends StatelessWidget {
  final DashboardStats stats;

  const _ProgressSection({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _DetailCard(
                icon: Icons.quiz_outlined,
                value: '${stats.totalQuizzes}',
                label: 'Quizzes Taken',
                color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
                iconColor: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _DetailCard(
                icon: Icons.emoji_events_outlined,
                value: '${stats.averageScore}%',
                label: 'Avg. Score',
                color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
                iconColor: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // Expanded(
            //   child: _DetailCard(
            //     icon: Icons.local_fire_department_outlined,
            //     value: '${stats.streak}',
            //     label: 'Day Streak',
            //     color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            //     iconColor: const Color(0xFFF59E0B), // Amber/Orange
            //   ),
            // ),
            // const SizedBox(width: 16),
            Expanded(
              child: _DetailCard(
                icon: Icons.topic_outlined,
                value: stats.bestTopic,
                label: 'Favorite Category',
                color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
                iconColor: const Color(0xFF8B5CF6), // Violet
                isSmallText: true,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color iconColor;
  final bool isSmallText;

  const _DetailCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.iconColor,
    this.isSmallText = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 130,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isSmallText || value.length > 8 ? 22 : 32,
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onSurface,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// HELPERS

IconData _getCategoryIcon(String category) {
  final cat = category.toLowerCase();
  if (cat.contains('history')) return Icons.history_edu;
  if (cat.contains('science') ||
      cat.contains('chemistry') ||
      cat.contains('physics')) {
    return Icons.science;
  }
  if (cat.contains('geography') || cat.contains('world')) return Icons.public;
  if (cat.contains('art')) return Icons.palette;
  if (cat.contains('tech') || cat.contains('code')) return Icons.computer;
  if (cat.contains('math')) return Icons.calculate;
  if (cat.contains('music')) return Icons.music_note;
  if (cat.contains('sport')) return Icons.sports_basketball;
  return Icons.school; // Default
}

Color _getCategoryColor(String category) {
  final cat = category.toLowerCase();
  if (cat.contains('history')) return const Color(0xFF8B5CF6); // Violet
  if (cat.contains('science')) return const Color(0xFFF59E0B); // Amber
  if (cat.contains('geography')) return const Color(0xFF3B82F6); // Blue
  if (cat.contains('art')) return const Color(0xFFEC4899); // Pink
  if (cat.contains('tech')) return const Color(0xFF10B981); // Emerald
  return const Color(0xFF6366F1); // Indigo Default
}
