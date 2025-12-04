import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../quiz/data/quiz_repository.dart';
import '../../quiz/domain/user_answer.dart';
import '../../quiz/domain/quiz_category.dart';

import 'history_filter_provider.dart';

import 'widgets/history_shimmer.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final allResultsAsync = ref.watch(allQuizResultsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filterState = ref.watch(historyFilterProvider);

    if (!allResultsAsync.hasValue) {
      return const HistoryShimmer();
    }

    return Container(
      color: colorScheme.surface,
      child: CustomScrollView(
        key: const PageStorageKey('history_scroll_view'),
        physics: const BouncingScrollPhysics(),
        slivers: [
          allResultsAsync.when(
            data: (results) {
              final filteredResults = results.where((result) {
                final title = result.quiz.title.toLowerCase();
                final category = result.quiz.category.toLowerCase();
                final difficulty = result.quiz.difficulty;

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
                return SliverFillRemaining(
                  hasScrollBody: false,
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
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index.isOdd) return const SizedBox(height: 12);
                    final itemIndex = index ~/ 2;
                    final result = filteredResults[itemIndex];
                    return _HistoryCard(result: result)
                        .animate()
                        .fadeIn(delay: Duration(milliseconds: 50 * itemIndex))
                        .slideY(begin: 0.1, end: 0);
                  }, childCount: filteredResults.length * 2 - 1),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) =>
                SliverFillRemaining(child: Center(child: Text('Error: $err'))),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends ConsumerWidget {
  final QuizResult result;

  const _HistoryCard({required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final iconData = _getCategoryIcon(result.quiz.category);
    final iconColor = _getCategoryColor(result.quiz.category);
    final difficultyColor = _getDifficultyColor(result.quiz.difficulty);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push('/results', extra: result);
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 2. Title & Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.quiz.title,
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
                          Icon(iconData, size: 16, color: iconColor),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              result.quiz.category,
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
                            result.quiz.difficulty[0].toUpperCase() +
                                result.quiz.difficulty.substring(1),
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

                // 3. Score
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${result.correctAnswers}/${result.totalQuestions}',
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

IconData _getCategoryIcon(String category) {
  // Try to match exact enum display name first
  try {
    final catEnum = QuizCategory.fromString(category);
    switch (catEnum) {
      case QuizCategory.technologyAndCoding:
        return Icons.computer;
      case QuizCategory.scienceAndNature:
        return Icons.science;
      case QuizCategory.historyAndPolitics:
        return Icons.history_edu;
      case QuizCategory.artsAndLiterature:
        return Icons.palette;
      case QuizCategory.entertainmentAndPopCulture:
        return Icons.movie;
      case QuizCategory.geographyAndTravel:
        return Icons.public;
      case QuizCategory.businessAndFinance:
        return Icons.attach_money;
      case QuizCategory.healthAndLifestyle:
        return Icons.favorite;
      case QuizCategory.sportsAndRecreation:
        return Icons.sports_basketball;
      case QuizCategory.generalKnowledge:
        return Icons.school;
    }
  } catch (_) {
    // Fallback to loose matching if needed
    final cat = category.toLowerCase();
    if (cat.contains('history')) return Icons.history_edu;
    if (cat.contains('science')) return Icons.science;
    if (cat.contains('geography')) return Icons.public;
    if (cat.contains('art')) return Icons.palette;
    if (cat.contains('tech') || cat.contains('code')) return Icons.computer;
    if (cat.contains('math')) return Icons.calculate;
    if (cat.contains('music')) return Icons.music_note;
    if (cat.contains('sport')) return Icons.sports_basketball;
    if (cat.contains('film') || cat.contains('cinema')) return Icons.movie;
    return Icons.school;
  }
}

Color _getCategoryColor(String category) {
  try {
    final catEnum = QuizCategory.fromString(category);
    switch (catEnum) {
      case QuizCategory.technologyAndCoding:
        return const Color(0xFF10B981);
      case QuizCategory.scienceAndNature:
        return const Color(0xFFF59E0B);
      case QuizCategory.historyAndPolitics:
        return const Color(0xFF8B5CF6);
      case QuizCategory.artsAndLiterature:
        return const Color(0xFFEC4899);
      case QuizCategory.entertainmentAndPopCulture:
        return const Color(0xFFF43F5E);
      case QuizCategory.geographyAndTravel:
        return const Color(0xFF3B82F6);
      case QuizCategory.businessAndFinance:
        return const Color(0xFF0EA5E9);
      case QuizCategory.healthAndLifestyle:
        return const Color(0xFFEF4444);
      case QuizCategory.sportsAndRecreation:
        return const Color(0xFFF97316);
      case QuizCategory.generalKnowledge:
        return const Color(0xFF6366F1);
    }
  } catch (_) {
    return const Color(0xFF6366F1);
  }
}

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
