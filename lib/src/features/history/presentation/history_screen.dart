import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rapidval/src/core/widgets/custom_app_bar.dart';

import '../../auth/data/auth_repository.dart';
import '../../quiz/data/quiz_repository.dart';
import '../../quiz/domain/user_answer.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allResultsAsync = ref.watch(allQuizResultsProvider);
    final user = ref.watch(authRepositoryProvider).currentUser;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverCustomAppBar(
            title: 'Quiz History',
            subtitle: 'Review your past quizzes',
            user: user,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withOpacity(0.5),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search history...',
                          hintStyle: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.tune, color: colorScheme.primary),
                  ),
                ],
              ),
            ),
          ),
          allResultsAsync.when(
            data: (results) {
              final filteredResults = results.where((result) {
                final title = result.quiz.title.toLowerCase();
                final category = result.quiz.category.toLowerCase();
                return title.contains(_searchQuery) ||
                    category.contains(_searchQuery);
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
                          color: colorScheme.onSurfaceVariant.withOpacity(0.5),
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
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
                // 1. Icon Container
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(iconData, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),

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
                              color: colorScheme.onSurfaceVariant.withOpacity(
                                0.5,
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
  if (cat.contains('film') || cat.contains('cinema')) return Icons.movie;
  return Icons.school;
}

Color _getCategoryColor(String category) {
  final cat = category.toLowerCase();
  if (cat.contains('history')) return const Color(0xFF8B5CF6);
  if (cat.contains('science')) return const Color(0xFFF59E0B);
  if (cat.contains('geography')) return const Color(0xFF3B82F6);
  if (cat.contains('art')) return const Color(0xFFEC4899);
  if (cat.contains('tech')) return const Color(0xFF10B981);
  if (cat.contains('film') || cat.contains('cinema')) {
    return const Color(0xFFF43F5E);
  }
  return const Color(0xFF6366F1);
}

Color _getDifficultyColor(String difficulty) {
  final diff = difficulty.toLowerCase();
  if (diff == 'easy') return const Color(0xFF22C55E);
  if (diff == 'medium') return const Color(0xFFF59E0B);
  if (diff == 'hard') return const Color(0xFFEF4444);
  return const Color(0xFF6366F1);
}
