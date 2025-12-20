import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:rapidval/src/features/quiz/domain/quiz_history_item.dart';
import '../../quiz/data/quiz_repository.dart';
import '../../quiz/presentation/quiz_state.dart';
import '../../quiz/presentation/quiz_controller.dart';
import '../data/daily_quiz_repository.dart';
import 'dashboard_stats_provider.dart';
import 'widgets/dashboard_shimmer.dart';
import 'widgets/daily_quiz_card.dart';
import 'widgets/daily_quiz_loading_card.dart';

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

    // Data Providers
    final quizHistoryAsync = ref.watch(quizHistoryProvider);
    final activeQuizProgressAsync = ref.watch(activeQuizProgressProvider);
    final statsAsync = ref.watch(dashboardStatsProvider);
    final dailyQuizAsync = ref.watch(dailyQuizProvider);

    // 1. Loading State Check
    final isLoading =
        !statsAsync.hasValue ||
        !activeQuizProgressAsync.hasValue ||
        !quizHistoryAsync.hasValue;

    return AnimatedSwitcher(
      duration: 400.ms,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: isLoading
          ? const DashboardShimmer(key: ValueKey('dashboard_shimmer'))
          : Scaffold(
              key: const ValueKey('dashboard_content'),
              backgroundColor: colorScheme.surface,

              // 2. Primary Action (Floating)
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () => context.push('/create-quiz'),
                icon: const Icon(Icons.add_rounded),
                label: const Text('New Quiz'),
                elevation: 2,
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),

              // 3. Main Scrollable Content
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Section A: Stats
                        if (statsAsync.hasValue)
                          _StatsRow(stats: statsAsync.value!),

                        const SizedBox(height: 24),

                        // Section: Daily Quiz
                        dailyQuizAsync.when(
                          data: (quiz) {
                            if (quiz == null) return const SizedBox.shrink();

                            final activeState =
                                activeQuizProgressAsync.value?.$1;
                            if (activeState != null &&
                                activeState.quiz.id == quiz.id) {
                              return const SizedBox.shrink();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _SectionTitle(
                                  title: 'Daily Challenge',
                                  icon: Icons.lightbulb_outline_rounded,
                                ),
                                const SizedBox(height: 12),
                                DailyQuizCard(quiz: quiz),
                                const SizedBox(height: 24),
                              ],
                            );
                          },
                          error: (_, __) => const SizedBox.shrink(),
                          loading: () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _SectionTitle(
                                title: 'Daily Challenge',
                                icon: Icons.lightbulb_outline_rounded,
                              ),
                              const SizedBox(height: 12),
                              const DailyQuizLoadingCard(),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),

                        // Section B: Active Quiz (Conditional)
                        if (activeQuizProgressAsync.value != null) ...[
                          const _SectionTitle(
                            title: 'Continue Learning',
                            icon: Icons.play_circle_outline_rounded,
                          ),
                          const SizedBox(height: 12),
                          _ActiveQuizHeroCard(
                            state: activeQuizProgressAsync.value!.$1,
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Section C: Recent History
                        if (quizHistoryAsync.value?.isNotEmpty ?? false) ...[
                          const _SectionTitle(
                            title: 'Recent History',
                            icon: Icons.history_rounded,
                          ),
                          const SizedBox(height: 12),
                          _RecentQuizzesContainer(
                            items: quizHistoryAsync.value!.take(3).toList(),
                          ),
                        ],
                      ]),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// COMPONENT: Active Quiz Hero Card
class _ActiveQuizHeroCard extends ConsumerWidget {
  final QuizState state;

  const _ActiveQuizHeroCard({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final total = state.quiz.questions.length;
    final current = state.currentQuestionIndex + 1;
    final progress = current / total;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.primary.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.12)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          await ref.read(quizControllerProvider.notifier).resumeQuiz();
          if (context.mounted) context.go('/quiz');
        },
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
                        Text(
                          state.quiz.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          state.quiz.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: colorScheme.onPrimary,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question $current of $total',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${(state.timeLeft / 60).ceil()} min remaining',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: colorScheme.surface,
                  valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }
}

// COMPONENT: Stats Row
class _StatsRow extends StatelessWidget {
  final DashboardStats stats;

  const _StatsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: 'Completed',
            value: stats.totalQuizzes.toString(),
            icon: Icons.check_circle_outline_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatTile(
            label: 'Avg. Score',
            value: '${stats.averageScore}%',
            icon: Icons.bar_chart_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 100.ms);
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.0,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// COMPONENT: Recent Quizzes List
class _RecentQuizzesContainer extends ConsumerWidget {
  final List<QuizHistoryItem> items;

  const _RecentQuizzesContainer({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;
          final isCompleted = item.result != null;

          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(
                      item.quiz.category,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getCategoryIcon(item.quiz.category),
                    size: 20,
                    color: _getCategoryColor(item.quiz.category),
                  ),
                ),
                title: Text(
                  item.quiz.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  item.quiz.category,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                trailing: isCompleted
                    ? _ScoreBadge(percentage: item.result!.percentage)
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Start',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                onTap: () async {
                  // Fetch full quiz details (including questions)
                  try {
                    final fullQuiz = await ref
                        .read(quizRepositoryProvider)
                        .getQuizById(item.quiz.id);

                    if (!context.mounted) return;

                    if (fullQuiz == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Unable to load quiz details'),
                        ),
                      );
                      return;
                    }

                    if (isCompleted) {
                      final fullResult = item.result!.copyWith(quiz: fullQuiz);
                      context.push('/results', extra: fullResult);
                    } else {
                      context.push('/quiz-setup', extra: fullQuiz);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error loading quiz: $e')),
                      );
                    }
                  }
                },
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
        }).toList(),
      ),
    ).animate().fadeIn().slideY(begin: 0.05, end: 0);
  }
}

class _ScoreBadge extends StatelessWidget {
  final double percentage;

  const _ScoreBadge({required this.percentage});

  @override
  Widget build(BuildContext context) {
    final color = _getScoreColor(percentage);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${percentage.toInt()}%',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

// COMPONENT: Section Title
class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

// HELPERS

IconData _getCategoryIcon(String category) {
  final cat = category.toLowerCase();
  if (cat.contains('history')) return Icons.history_edu;
  if (cat.contains('science') || cat.contains('physics')) return Icons.science;
  if (cat.contains('code') || cat.contains('tech')) return Icons.terminal;
  if (cat.contains('geo')) return Icons.public;
  if (cat.contains('art')) return Icons.palette;
  return Icons.school;
}

Color _getCategoryColor(String category) {
  final cat = category.toLowerCase();
  if (cat.contains('history')) return const Color(0xFF8B5CF6);
  if (cat.contains('science')) return const Color(0xFFF59E0B);
  if (cat.contains('tech')) return const Color(0xFF10B981);
  return const Color(0xFF6366F1);
}

Color _getScoreColor(double percentage) {
  if (percentage >= 80) return const Color(0xFF22C55E);
  if (percentage >= 60) return const Color(0xFFF59E0B);
  return const Color(0xFFEF4444);
}
