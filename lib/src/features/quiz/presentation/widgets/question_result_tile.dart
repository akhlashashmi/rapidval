import 'package:flutter/material.dart';
import '../../domain/quiz_entity.dart';
import '../../domain/user_answer.dart';

class QuestionResultTile extends StatelessWidget {
  final int index;
  final QuizQuestion question;
  final UserAnswer userAnswer;
  final bool isCorrect;
  final bool isSkipped;
  final VoidCallback? onTap;

  const QuestionResultTile({
    super.key,
    required this.index,
    required this.question,
    required this.userAnswer,
    required this.isCorrect,
    required this.isSkipped,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color statusColor;
    IconData statusIcon;

    if (isSkipped) {
      statusColor = colorScheme.onSurfaceVariant;
      statusIcon = Icons.remove_circle_outline_rounded;
    } else if (isCorrect) {
      statusColor = const Color(0xFF22C55E);
      statusIcon = Icons.check_circle_rounded;
    } else {
      statusColor = const Color(0xFFEF4444);
      statusIcon = Icons.cancel_rounded;
    }

    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.12)),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(statusIcon, color: statusColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Question ${index + 1}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isSkipped) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Skipped',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      question.question.replaceAll(RegExp(r'[\#\*]'), ''),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // UNIFIED FEEDBACK SECTION
                    if (!isSkipped)
                      _buildCombinedFeedback(context, theme, colorScheme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCombinedFeedback(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    List<_FeedbackItem> items = [];

    if (question.type == QuizQuestionType.multiple) {
      // Multiple Choice Logic
      final userIndices = userAnswer.selectedIndices.toSet();
      final correctIndices = question.correctIndices.toSet();
      if (correctIndices.isEmpty) {
        correctIndices.add(question.correctOptionIndex);
      }
      final allIndices = {...userIndices, ...correctIndices}.toList()..sort();

      for (var idx in allIndices) {
        final isSelected = userIndices.contains(idx);
        final isActuallyCorrect = correctIndices.contains(idx);
        final text = question.options[idx];
        Color itemColor;
        IconData itemIcon;
        String label;

        if (isSelected && !isActuallyCorrect) {
          itemColor = const Color(0xFFEF4444);
          itemIcon = Icons.cancel_outlined;
          label = 'Incorrect selection';
        } else if (!isSelected && isActuallyCorrect) {
          itemColor = const Color(0xFFF59E0B);
          itemIcon = Icons.remove_circle_outline;
          label = 'Missed correct option';
        } else {
          itemColor = const Color(0xFF22C55E);
          itemIcon = Icons.check_circle_outline;
          label = 'Correct';
        }

        items.add(
          _FeedbackItem(
            text: text,
            label: label,
            color: itemColor,
            icon: itemIcon,
          ),
        );
      }
    } else {
      // Single Choice Logic
      if (isCorrect) {
        items.add(
          _FeedbackItem(
            text: question.options[question.correctOptionIndex],
            label: 'Your Answer',
            color: const Color(0xFF22C55E),
            icon: Icons.check_circle_outline,
          ),
        );
      } else {
        // Incorrect: Show User Answer then Correct Answer
        items.add(
          _FeedbackItem(
            text: question.options[userAnswer.selectedOptionIndex],
            label: 'Your Answer',
            color: const Color(0xFFEF4444),
            icon: Icons.cancel_outlined,
          ),
        );
        items.add(
          _FeedbackItem(
            text: question.options[question.correctOptionIndex],
            label: 'Correct Answer',
            color: const Color(0xFF22C55E),
            icon: Icons.check_circle_outline,
          ),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(items[i].icon, size: 16, color: items[i].color),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        items[i].text,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: items[i].color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _FeedbackItem {
  final String text;
  final String label;
  final Color color;
  final IconData icon;

  _FeedbackItem({
    required this.text,
    required this.label,
    required this.color,
    required this.icon,
  });
}
