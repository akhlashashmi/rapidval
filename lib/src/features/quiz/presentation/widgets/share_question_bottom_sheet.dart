import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/quiz_entity.dart';

class ShareQuestionBottomSheet extends StatefulWidget {
  final QuizQuestion question;
  final int questionIndex;
  final String quizTitle;
  final String category;

  const ShareQuestionBottomSheet({
    super.key,
    required this.question,
    required this.questionIndex,
    required this.quizTitle,
    required this.category,
  });

  @override
  State<ShareQuestionBottomSheet> createState() =>
      _ShareQuestionBottomSheetState();
}

class _ShareQuestionBottomSheetState extends State<ShareQuestionBottomSheet> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _showHint = false;
  bool _revealAnswer = true;
  bool _isSharing = false;

  Future<void> _shareQuestion() async {
    setState(() => _isSharing = true);

    try {
      final Uint8List? imageBytes = await _screenshotController.capture(
        delay: const Duration(milliseconds: 50),
        pixelRatio: 3.0,
      );

      if (imageBytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to generate image')),
          );
        }
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/rapidval_q${widget.questionIndex + 1}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: _revealAnswer
            ? 'Check out this quiz question! 🧠'
            : 'Can you answer this? 🤔',
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error sharing: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final question = widget.question;
    final hasHint = question.hint != null && question.hint!.isNotEmpty;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Share Question',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        'Customize and share with friends',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Close button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  iconSize: 22,
                  color: colorScheme.onSurfaceVariant,
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(36, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
          // Divider(
          //   height: 1,
          //   thickness: 0.5,
          //   color: colorScheme.outline.withValues(alpha: 0.15),
          // ),

          // Scrollable Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Share Card Preview
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.2,
                      ),

                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Screenshot(
                      controller: _screenshotController,
                      child: _ShareCard(
                        question: question,
                        questionIndex: widget.questionIndex,
                        quizTitle: widget.quizTitle,
                        category: widget.category,
                        showHint: _showHint,
                        revealAnswer: _revealAnswer,
                      ),
                    ).animate().fadeIn(duration: 200.ms),
                  ),

                  const SizedBox(height: 16),

                  // Configuration Options
                  _ConfigOption(
                    title: 'Reveal Answer',
                    subtitle: _revealAnswer
                        ? 'Correct answers are shown'
                        : 'Share as a challenge',
                    icon: Icons.visibility_rounded,
                    isEnabled: _revealAnswer,
                    onTap: () => setState(() => _revealAnswer = !_revealAnswer),
                  ),

                  const SizedBox(height: 8),

                  if (hasHint)
                    _ConfigOption(
                      title: 'Show Hint',
                      subtitle: _showHint
                          ? 'Hint will be included'
                          : 'No hint in shared image',
                      icon: Icons.lightbulb_outline_rounded,
                      isEnabled: _showHint,
                      onTap: () => setState(() => _showHint = !_showHint),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Share Button (Fixed at bottom)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: AppButton(
                text: _isSharing ? 'Preparing...' : 'Share',
                onPressed: _isSharing ? null : _shareQuestion,
                isLoading: _isSharing,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Configuration toggle option
class _ConfigOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isEnabled;
  final VoidCallback onTap;

  const _ConfigOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isEnabled
              ? colorScheme.primary.withValues(alpha: 0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isEnabled
                ? Colors.transparent
                : colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isEnabled
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: isEnabled,
              onChanged: (_) => onTap(),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}

/// The share card that gets captured as an image
class _ShareCard extends StatelessWidget {
  final QuizQuestion question;
  final int questionIndex;
  final String quizTitle;
  final String category;
  final bool showHint;
  final bool revealAnswer;

  const _ShareCard({
    required this.question,
    required this.questionIndex,
    required this.quizTitle,
    required this.category,
    required this.showHint,
    required this.revealAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        // Removed border and radius as requested for the shared file
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: Title and Category
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Text(
                  category.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 6),

                // Quiz Title
                Text(
                  quizTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtle divider (acts as visual anchor)
                Container(
                  width: 36,
                  height: 3,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Question Text
          MarkdownBody(
            data: question.question,
            shrinkWrap: true,
            styleSheet: MarkdownStyleSheet(
              p: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: colorScheme.onSurface,
              ),
              pPadding: EdgeInsets.zero,
              strong: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              code: TextStyle(
                fontFamily: 'monospace',
                backgroundColor: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                color: colorScheme.primary,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Options
          ...List.generate(question.options.length, (index) {
            final isCorrect = question.type == QuizQuestionType.multiple
                ? question.correctIndices.contains(index) ||
                      (question.correctIndices.isEmpty &&
                          question.correctOptionIndex == index)
                : question.correctOptionIndex == index;

            final showAsCorrect = revealAnswer && isCorrect;

            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: showAsCorrect
                    ? Colors.green.withValues(alpha: 0.08)
                    : colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // Option indicator
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: question.type == QuizQuestionType.multiple
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                      borderRadius: question.type == QuizQuestionType.multiple
                          ? BorderRadius.circular(3)
                          : null,
                      color: showAsCorrect ? Colors.green : Colors.transparent,
                      border: Border.all(
                        color: showAsCorrect
                            ? Colors.green
                            : colorScheme.outline.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: showAsCorrect
                        ? Icon(
                            question.type == QuizQuestionType.multiple
                                ? Icons.check
                                : Icons.circle,
                            size: question.type == QuizQuestionType.multiple
                                ? 10
                                : 6,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      question.options[index],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: showAsCorrect
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Hint
          if (showHint &&
              question.hint != null &&
              question.hint!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_rounded,
                    color: Colors.amber.shade600,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      question.hint!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.amber.shade800,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),

          // Footer
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            // decoration: BoxDecoration(
            //   color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            //   borderRadius: BorderRadius.circular(12),
            //   border: Border.all(
            //     color: colorScheme.outline.withValues(alpha: 0.1),
            //   ),
            // ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.googlePlay,
                  size: 14,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GET IT ON',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 7,
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Google Play',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 16,
                  width: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
                Text(
                  'RapidVal',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.primary,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
