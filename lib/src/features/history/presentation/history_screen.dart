import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../quiz/data/quiz_repository.dart';
import '../../quiz/domain/user_answer.dart';
import '../../quiz/domain/quiz_history_item.dart';
import '../../quiz/presentation/quiz_controller.dart'; // For startQuiz
import '../../dashboard/presentation/dashboard_controller.dart'; // For timePerQuestion

import 'history_filter_provider.dart';

import 'history_selection_provider.dart';
import 'widgets/history_shimmer.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    // Changed to quizHistoryProvider
    final historyAsync = ref.watch(quizHistoryProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filterState = ref.watch(historyFilterProvider);
    final selectionState = ref.watch(historySelectionProvider);
    final isSelectionMode = selectionState.isNotEmpty;

    return Container(
      color: colorScheme.surface,
      child: AnimatedSwitcher(
        duration: 400.ms,
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: historyAsync.when(
          data: (historyItems) {
            final filteredResults = historyItems.where((item) {
              final title = item.quiz.title.toLowerCase();
              final category = item.quiz.category.toLowerCase();
              final difficulty = item.quiz.difficulty;

              final matchesSearch =
                  title.contains(filterState.searchQuery) ||
                  category.contains(filterState.searchQuery);

              final matchesDifficulty =
                  filterState.selectedDifficulty == null ||
                  difficulty.toLowerCase() ==
                      filterState.selectedDifficulty!.toLowerCase();

              final matchesCategory =
                  filterState.selectedCategories.isEmpty ||
                  filterState.selectedCategories.any(
                    (c) => category.toLowerCase().contains(c.toLowerCase()),
                  );

              return matchesSearch && matchesDifficulty && matchesCategory;
            }).toList();

            if (filteredResults.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => ref.refresh(quizHistoryProvider.future),
                child: CustomScrollView(
                  key: const ValueKey('empty_list'),
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history_toggle_off,
                              size: 64,
                              color: colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No quizzes found',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => ref.refresh(quizHistoryProvider.future),
              child: CustomScrollView(
                key: const ValueKey('history_list'),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index.isOdd) return const SizedBox(height: 12);
                        final itemIndex = index ~/ 2;
                        final item = filteredResults[itemIndex];
                        return _HistoryCard(
                              item: item,
                              isSelected: selectionState.contains(item.quiz.id),
                              isSelectionMode: isSelectionMode,
                            )
                            .animate()
                            .fadeIn(
                              delay: Duration(milliseconds: 50 * itemIndex),
                              duration: 300.ms,
                              curve: Curves.easeOut,
                            )
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              duration: 300.ms,
                              curve: Curves.easeOut,
                            );
                      }, childCount: filteredResults.length * 2 - 1),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const HistoryShimmer(key: ValueKey('history_shimmer')),
          error: (err, stack) => Center(
            key: const ValueKey('history_error'),
            child: Text('Error: $err'),
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends ConsumerWidget {
  final QuizHistoryItem item;
  final bool isSelected;
  final bool isSelectionMode;

  const _HistoryCard({
    required this.item,
    required this.isSelected,
    required this.isSelectionMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final difficultyColor = _getDifficultyColor(item.quiz.difficulty);
    final isCompleted = item.result != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primaryContainer.withValues(alpha: 0.1)
            : colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.5)
              : colorScheme.primary.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (isSelectionMode) {
              ref.read(historySelectionProvider.notifier).toggle(item.quiz.id);
            } else {
              if (isCompleted) {
                context.push('/results', extra: item.result);
              } else {
                // Pending/Not Attempted: Start the quiz
                final dashboardConfig = ref
                    .read(dashboardControllerProvider)
                    .value;
                final timePerQuestion =
                    dashboardConfig?.timePerQuestionSeconds ?? 15;

                ref
                    .read(quizControllerProvider.notifier)
                    .startQuiz(item.quiz, timePerQuestion);
                context.push('/quiz');
              }
            }
          },
          onLongPress: () {
            ref.read(historySelectionProvider.notifier).toggle(item.quiz.id);
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Selection Checkbox (Animated)
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: isSelectionMode
                      ? Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Icon(
                            isSelected
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // 2. Title & Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.quiz.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              item.quiz.category,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.circle,
                              size: 4,
                              color: colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          Text(
                            item.quiz.difficulty[0].toUpperCase() +
                                item.quiz.difficulty.substring(1),
                            style: TextStyle(
                              color: difficultyColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3. Score or Pending Status
                if (!isSelectionMode)
                  isCompleted
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${item.result!.correctAnswers}/${item.result!.totalQuestions}',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'correct',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        )
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// HELPERS
// -----------------------------------------------------------------------------

Color _getDifficultyColor(String difficulty) {
  final diff = difficulty.toLowerCase();
  if (diff == 'beginner') return const Color(0xFF22C55E);
  if (diff == 'intermediate') return const Color(0xFFF59E0B);
  if (diff == 'advanced') return const Color(0xFFEF4444);
  // Fallback for old data
  if (diff == 'easy') return const Color(0xFF22C55E);
  if (diff == 'medium') return const Color(0xFFF59E0B);
  if (diff == 'hard') return const Color(0xFFEF4444);
  return const Color(0xFF6366F1);
}
