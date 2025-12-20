import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import '../domain/user_answer.dart';
import '../domain/quiz_entity.dart';
import 'quiz_controller.dart';
import '../../../core/widgets/app_outlined_button.dart';
import '../../../core/widgets/app_button.dart';
import 'widgets/report_bottom_sheet.dart';
import 'widgets/share_question_bottom_sheet.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final bool isReviewMode;
  final QuizResult? quizResult;
  final String? returnPath;

  const QuizScreen({
    super.key,
    this.isReviewMode = false,
    this.quizResult,
    this.returnPath,
  });

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _timerPulseController;
  int _reviewIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _timerPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timerPulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    if (!widget.isReviewMode) {
      ref.read(quizControllerProvider.notifier).pauseQuiz();
    }
    super.deactivate();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only watch question index and completion status
    // userAnswers is watched separately in options section to avoid rebuilding question
    final currentQuestionIndex = ref.watch(
      quizControllerProvider.select(
        (state) => state?.currentQuestionIndex ?? 0,
      ),
    );
    final isCompleted = ref.watch(
      quizControllerProvider.select((state) => state?.isCompleted ?? false),
    );
    final quizState = ref.read(quizControllerProvider);

    if (quizState == null && !widget.isReviewMode) return _buildNoQuizState();
    if (isCompleted && !widget.isReviewMode) {
      _handleQuizCompletion();
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (widget.isReviewMode && widget.quizResult == null) {
      return _buildErrorState();
    }

    final quiz = widget.isReviewMode
        ? widget.quizResult!.quiz
        : quizState!.quiz;
    final currentIndex = widget.isReviewMode
        ? _reviewIndex
        : currentQuestionIndex;
    final question = quiz.questions[currentIndex];
    final totalQuestions = quiz.questions.length;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Isolate header to prevent full screen rebuilds
            Consumer(
              builder: (context, ref, _) {
                final quizState = ref.watch(quizControllerProvider);
                final timeLeft = widget.isReviewMode
                    ? 0
                    : (quizState?.timeLeft ?? 0);
                final timePerQuestion = widget.isReviewMode
                    ? 0
                    : ref.read(quizControllerProvider.notifier).timePerQuestion;

                return _QuizHeader(
                  currentIndex: currentIndex,
                  totalQuestions: totalQuestions,
                  timeLeft: timeLeft,
                  timePerQuestion: timePerQuestion,
                  isReviewMode: widget.isReviewMode,
                  onClose: () => _handleClose(context),
                  onReport: () =>
                      _showReportDialog(context, question, quiz.id, quiz.title),
                  onHint: question.hint != null
                      ? () => _showHintSnackBar(context, question.hint!)
                      : null,
                  onShare: widget.isReviewMode
                      ? () => _showShareDialog(
                          context,
                          question,
                          currentIndex,
                          quiz.title,
                          quiz.category,
                        )
                      : null,
                );
              },
            ),

            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ).copyWith(top: 12),
                physics: const BouncingScrollPhysics(),
                children: [
                  // Question display - static, doesn't depend on userAnswers
                  _QuestionDisplay(question: question)
                      .animate(key: ValueKey(currentIndex))
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),

                  const SizedBox(height: 12),

                  // Selection type hint
                  if (!widget.isReviewMode)
                    _SelectionTypeHint(
                          isMultiple:
                              question.type == QuizQuestionType.multiple,
                        )
                        .animate(key: ValueKey(currentIndex))
                        .fadeIn(delay: 200.ms)
                        .slideX(begin: -0.05, end: 0),

                  const SizedBox(height: 20),

                  // Options section - isolated with its own Consumer
                  Consumer(
                    builder: (context, ref, _) {
                      final userAnswers = ref.watch(
                        quizControllerProvider.select(
                          (state) => state?.userAnswers ?? [],
                        ),
                      );

                      final UserAnswer? userAnswer = widget.isReviewMode
                          ? widget.quizResult!.answers.firstWhere(
                              (a) => a.questionIndex == currentIndex,
                              orElse: () => UserAnswer(
                                questionIndex: currentIndex,
                                selectedOptionIndex: -1,
                                answeredAt: DateTime.now(),
                              ),
                            )
                          : userAnswers.cast<UserAnswer?>().firstWhere(
                              (a) => a?.questionIndex == currentIndex,
                              orElse: () => null,
                            );

                      return Column(
                        children: List.generate(question.options.length, (
                          index,
                        ) {
                          bool isSelected = false;
                          if (userAnswer != null) {
                            if (userAnswer.selectedIndices.isNotEmpty) {
                              isSelected = userAnswer.selectedIndices.contains(
                                index,
                              );
                            } else {
                              isSelected =
                                  userAnswer.selectedOptionIndex == index;
                            }
                          }

                          bool isCorrect = false;
                          if (question.type == QuizQuestionType.multiple) {
                            isCorrect = question.correctIndices.contains(index);
                            if (question.correctIndices.isEmpty &&
                                question.correctOptionIndex == index) {
                              isCorrect = true;
                            }
                          } else {
                            isCorrect = question.correctOptionIndex == index;
                          }

                          final VoidCallback? onTap = widget.isReviewMode
                              ? null
                              : () {
                                  ref
                                      .read(quizControllerProvider.notifier)
                                      .answerQuestion(index);
                                };

                          return _OptionTile(
                            text: question.options[index],
                            index: index,
                            isSelected: isSelected,
                            isMultiple:
                                question.type == QuizQuestionType.multiple,
                            isCorrectContext: widget.isReviewMode
                                ? isCorrect
                                : null,
                            isWrongContext: widget.isReviewMode
                                ? (isSelected && !isCorrect)
                                : null,
                            onTap: onTap,
                          );
                        }),
                      );
                    },
                  ),

                  if (widget.isReviewMode) ...[
                    const SizedBox(height: 24),
                    _ExplanationCard(explanation: question.explanation)
                        .animate()
                        .fadeIn(delay: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 80),
                  ],
                ],
              ),
            ),

            // Bottom bar with its own Consumer for isAnswered and canGoPrevious
            Consumer(
              builder: (context, ref, _) {
                final userAnswers = ref.watch(
                  quizControllerProvider.select(
                    (state) => state?.userAnswers ?? [],
                  ),
                );
                final isAnswered =
                    widget.isReviewMode ||
                    userAnswers.any((a) => a.questionIndex == currentIndex);

                // Check if we can go to previous question
                final canGoPrevious = widget.isReviewMode
                    ? currentIndex > 0
                    : ref.read(quizControllerProvider.notifier).canGoPrevious;

                return _BottomActionBar(
                  isReviewMode: widget.isReviewMode,
                  isAnswered: isAnswered,
                  currentIndex: currentIndex,
                  totalQuestions: totalQuestions,
                  canGoPrevious: canGoPrevious,
                  onNext: () {
                    if (widget.isReviewMode) {
                      setState(() => _reviewIndex++);
                      _scrollToTop();
                    } else {
                      ref.read(quizControllerProvider.notifier).nextQuestion();
                      _scrollToTop();
                    }
                  },
                  onPrevious: () {
                    if (widget.isReviewMode) {
                      if (currentIndex > 0) {
                        setState(() => _reviewIndex--);
                        _scrollToTop();
                      }
                    } else {
                      // Try to go to previous question, if can't then exit
                      final wentBack = ref
                          .read(quizControllerProvider.notifier)
                          .previousQuestion();
                      if (wentBack) {
                        _scrollToTop();
                      } else {
                        // Already at first question, exit quiz
                        _handleClose(context);
                      }
                    }
                  },
                  onCloseReview: () => Navigator.pop(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleQuizCompletion() {
    final result = ref.read(quizControllerProvider.notifier).getQuizResult();
    if (result != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pushReplacement(
          '/results',
          extra: {'result': result, 'returnPath': widget.returnPath},
        );
      });
    }
  }

  void _handleClose(BuildContext context) {
    if (widget.isReviewMode) {
      if (widget.returnPath != null) {
        context.go(widget.returnPath!);
      } else if (context.canPop()) {
        context.pop();
      } else {
        context.go('/dashboard');
      }
    } else {
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Exit Quiz?'),
          content: const Text('Progress will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(c);
                if (widget.returnPath != null) {
                  context.go(widget.returnPath!);
                } else if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/dashboard');
                }
              },
              child: const Text('Exit'),
            ),
          ],
        ),
      );
    }
  }

  void _showHintSnackBar(BuildContext context, String hint) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hint: $hint'),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
      ),
    );
  }

  void _showShareDialog(
    BuildContext context,
    QuizQuestion question,
    int questionIndex,
    String quizTitle,
    String category,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareQuestionBottomSheet(
        question: question,
        questionIndex: questionIndex,
        quizTitle: quizTitle,
        category: category,
      ),
    );
  }

  Widget _buildNoQuizState() =>
      const Scaffold(body: Center(child: Text("No Active Quiz")));
  Widget _buildErrorState() =>
      const Scaffold(body: Center(child: Text("Error loading results")));

  void _showReportDialog(
    BuildContext context,
    QuizQuestion question,
    String quizId,
    String quizTitle,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReportBottomSheet(
        onSubmit: (reason, comment) {
          _submitReport(
            question,
            reason,
            quizId,
            quizTitle: quizTitle,
            additionalComments: comment,
          );
        },
      ),
    );
  }

  void _submitReport(
    QuizQuestion question,
    String reason,
    String quizId, {
    String? quizTitle,
    String? additionalComments,
  }) {
    ref
        .read(quizControllerProvider.notifier)
        .reportQuestion(
          questionId: question.id,
          questionText: question.question,
          options: question.options,
          reportReason: reason,
          quizId: quizId,
          quizTitle: quizTitle,
          additionalComments: additionalComments,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report submitted. Thank you for your feedback.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _QuizHeader extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final int timeLeft;
  final int timePerQuestion;
  final bool isReviewMode;
  final VoidCallback onClose;
  final VoidCallback onReport;
  final VoidCallback? onHint;
  final VoidCallback? onShare;

  const _QuizHeader({
    required this.currentIndex,
    required this.totalQuestions,
    required this.timeLeft,
    required this.timePerQuestion,
    required this.isReviewMode,
    required this.onClose,
    required this.onReport,
    this.onHint,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Leading Close Button
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    foregroundColor: colorScheme.onSurface,
                  ),
                ),

                // Center Title
                Expanded(
                  child: Text(
                    isReviewMode
                        ? "Review Mode"
                        : "Question ${currentIndex + 1} of $totalQuestions",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),

                // Actions Row
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Report Button
                    IconButton(
                      onPressed: onReport,
                      icon: const Icon(Icons.flag_outlined, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        foregroundColor: colorScheme.onSurfaceVariant,
                      ),
                      tooltip: "Report",
                    ),
                    const SizedBox(width: 4),
                    // Share in review mode, Hint otherwise
                    if (isReviewMode)
                      IconButton(
                        onPressed: onShare,
                        icon: Icon(
                          Icons.share_rounded,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.primaryContainer
                              .withValues(alpha: 0.3),
                          foregroundColor: colorScheme.primary,
                        ),
                        tooltip: "Share Question",
                      )
                    else
                      IconButton(
                        onPressed: onHint,
                        icon: Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 20,
                          color: onHint != null
                              ? Colors.amber.shade600
                              : colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.3,
                                ),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: onHint != null
                              ? Colors.amber.withValues(alpha: 0.15)
                              : colorScheme.surfaceContainerHighest.withValues(
                                  alpha: 0.3,
                                ),
                        ),
                        tooltip: "Show Hint",
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (!isReviewMode)
            _SegmentedProgressBar(
              currentIndex: currentIndex,
              totalQuestions: totalQuestions,
              timeLeft: timeLeft,
              timePerQuestion: timePerQuestion,
            ),
        ],
      ),
    );
  }
}

/// A segmented progress bar where each segment represents a question.
/// The timer chip moves within the current question's segment.
class _SegmentedProgressBar extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final int timeLeft;
  final int timePerQuestion;

  const _SegmentedProgressBar({
    required this.currentIndex,
    required this.totalQuestions,
    required this.timeLeft,
    required this.timePerQuestion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLowTime = timeLeft <= 5;
    final isCritical = timeLeft <= 3;

    return SizedBox(
      height: 32,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final segmentWidth = totalWidth / totalQuestions;
          final chipWidth = 42.0;

          // Calculate chip position within current segment
          // At full time (e.g., 10s), chip is at the START (left) of segment
          // At 0 time, chip is at the END (right) of segment
          final timeProgress = timePerQuestion > 0
              ? timeLeft / timePerQuestion
              : 0.0;

          // Current segment boundaries
          final segmentStart = currentIndex * segmentWidth;
          final availableWidth = segmentWidth - chipWidth;

          // Chip position: starts at left side, moves to right as time decreases
          // (1 - timeProgress) means: 0 at full time, 1 at zero time
          final chipOffset =
              segmentStart + (availableWidth * (1 - timeProgress));
          final clampedChipOffset = chipOffset.clamp(
            0.0,
            totalWidth - chipWidth,
          );

          // Fill amount - follows the chip position
          final totalFill = chipOffset + chipWidth;

          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Background track
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Filled progress (follows chip) - with smooth color animation
              TweenAnimationBuilder<Color?>(
                tween: ColorTween(
                  end: isCritical
                      ? colorScheme.error
                      : isLowTime
                      ? Colors.orange
                      : colorScheme.primary,
                ),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                builder: (context, color, _) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 4,
                  width: totalFill.clamp(0.0, totalWidth),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Timer chip - with smooth color animation
              AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                left: clampedChipOffset,
                child: TweenAnimationBuilder<Color?>(
                  tween: ColorTween(
                    end: isCritical
                        ? colorScheme.error
                        : isLowTime
                        ? Colors.orange
                        : colorScheme.primary,
                  ),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  builder: (context, chipColor, child) => Container(
                    width: chipWidth,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: chipColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: (chipColor ?? colorScheme.primary).withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      _formatTime(timeLeft),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        fontSize:
                            (theme.textTheme.labelSmall?.fontSize ?? 11) - 1,
                        color: isCritical
                            ? colorScheme.onError
                            : colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatTime(int seconds) {
    final s = seconds % 60;
    return '${s.toString().padLeft(2, '0')}s';
  }
}

class _QuestionDisplay extends StatelessWidget {
  final QuizQuestion question;

  const _QuestionDisplay({required this.question});

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: question.question,
      selectable: true,
      styleSheet: _buildProfessionalMarkdownStyle(context, isQuestion: true),
    );
  }
}

class _SelectionTypeHint extends StatelessWidget {
  final bool isMultiple;

  const _SelectionTypeHint({required this.isMultiple});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isMultiple ? Icons.check_box_outlined : Icons.radio_button_unchecked,
          size: 14,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 6),
        Text(
          isMultiple ? 'Select all that apply' : 'Select one answer',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String text;
  final int index;
  final bool isSelected;
  final bool isMultiple;
  final bool? isCorrectContext;
  final bool? isWrongContext;
  final VoidCallback? onTap;

  const _OptionTile({
    required this.text,
    required this.index,
    required this.isSelected,
    this.isMultiple = false,
    this.isCorrectContext,
    this.isWrongContext,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color borderColor = theme.colorScheme.outline.withValues(
      alpha: 0.2,
    ); // Matching AppOutlinedButton
    Color backgroundColor = Colors.transparent; // Default transparent
    Color indicatorBg = theme.colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.5,
    );
    Color indicatorText = theme.colorScheme.onSurfaceVariant;

    if (isCorrectContext == true) {
      borderColor = Colors.transparent; // No border
      backgroundColor = Colors.green.withValues(alpha: 0.1);
      indicatorBg = Colors.green;
      indicatorText = Colors.white;
    } else if (isWrongContext == true) {
      borderColor = Colors.transparent; // No border
      backgroundColor = Colors.red.withValues(alpha: 0.1);
      indicatorBg = Colors.red;
      indicatorText = Colors.white;
    } else if (isSelected) {
      borderColor = Colors.transparent; // No border when selected
      backgroundColor = theme.colorScheme.primary.withValues(
        alpha: 0.08,
      ); // Lightest shade
      indicatorBg = theme.colorScheme.primary;
      indicatorText = theme.colorScheme.onPrimary;
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ), // Reduced spacing between tiles
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(12), // Reduced internal padding
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: 1, // Consistent width
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Top align content
            children: [
              // Selection indicator (checkbox for multi, radio for single)
              Container(
                margin: const EdgeInsets.only(
                  top: 2,
                ), // Slight offset to align with text cap height
                width: 20, // Smaller size
                height: 20, // Smaller size
                decoration: BoxDecoration(
                  color:
                      isSelected ||
                          isCorrectContext == true ||
                          isWrongContext == true
                      ? indicatorBg
                      : Colors.transparent,
                  shape: isMultiple ? BoxShape.rectangle : BoxShape.circle,
                  borderRadius: isMultiple ? BorderRadius.circular(4) : null,
                  border: Border.all(
                    color:
                        isSelected ||
                            isCorrectContext == true ||
                            isWrongContext == true
                        ? indicatorBg
                        : theme.colorScheme.outline.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: isCorrectContext == true
                    ? Icon(
                        isMultiple ? Icons.check : Icons.circle,
                        size: isMultiple ? 14 : 10, // Smaller inner icons
                        color: Colors.white,
                      )
                    : isWrongContext == true
                    ? const Icon(Icons.close, size: 14, color: Colors.white)
                    : isSelected
                    ? Icon(
                        isMultiple ? Icons.check : Icons.circle,
                        size: isMultiple ? 14 : 10, // Smaller inner icons
                        color: indicatorText,
                      )
                    : null,
              ),
              const SizedBox(
                width: 12,
              ), // Reduced spacing between indicator and text
              Expanded(
                child: MarkdownBody(
                  data: text,
                  styleSheet: _buildProfessionalMarkdownStyle(
                    context,
                    isQuestion: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final bool isReviewMode;
  final bool isAnswered;
  final int currentIndex;
  final int totalQuestions;
  final bool canGoPrevious;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onCloseReview;

  const _BottomActionBar({
    required this.isReviewMode,
    required this.isAnswered,
    required this.currentIndex,
    required this.totalQuestions,
    required this.canGoPrevious,
    required this.onNext,
    required this.onPrevious,
    required this.onCloseReview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine back button text based on context
    final String backButtonText = canGoPrevious ? "Previous" : "Exit";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppOutlinedButton(
              onPressed: onPrevious,
              text: backButtonText,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppButton(
              onPressed: isReviewMode
                  ? (currentIndex == totalQuestions - 1
                        ? onCloseReview
                        : onNext)
                  : (isAnswered ? onNext : null),
              text: isReviewMode && currentIndex == totalQuestions - 1
                  ? "Close"
                  : "Next",
            ),
          ),
        ],
      ),
    );
  }
}

class _ExplanationCard extends StatelessWidget {
  final String explanation;

  const _ExplanationCard({required this.explanation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Explanation',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          MarkdownBody(
            data: explanation,
            styleSheet: _buildProfessionalMarkdownStyle(
              context,
              isQuestion: false,
            ),
          ),
        ],
      ),
    );
  }
}

MarkdownStyleSheet _buildProfessionalMarkdownStyle(
  BuildContext context, {
  required bool isQuestion,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  // Use bodyMedium for options (smaller), bodyLarge for questions
  final baseText = isQuestion
      ? theme.textTheme.bodyLarge
      : theme.textTheme.bodyMedium;

  // All base text is normal weight, as requested.
  const FontWeight pWeight = FontWeight.normal;

  return MarkdownStyleSheet(
    p: baseText?.copyWith(
      height: 1.5,
      fontWeight: pWeight,
      color: colorScheme.onSurface,
    ),
    pPadding: EdgeInsets.zero,
    strong: baseText?.copyWith(
      fontWeight: FontWeight.w700,
      color: colorScheme.onSurface,
    ),
    em: baseText?.copyWith(
      fontStyle: FontStyle.italic,
      color: colorScheme.onSurface,
    ),
    code: TextStyle(
      fontFamily: 'monospace',
      backgroundColor: colorScheme.surfaceContainerHighest,
      color: colorScheme.primary,
      fontSize: (baseText?.fontSize ?? 16.0) - 2,
      fontWeight: FontWeight.w500,
    ),
    codeblockDecoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
    ),
    codeblockPadding: const EdgeInsets.all(12),
    blockquoteDecoration: BoxDecoration(
      color: colorScheme.secondaryContainer.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(4),
      border: Border(left: BorderSide(color: colorScheme.secondary, width: 3)),
    ),
    blockquotePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    blockquote: baseText?.copyWith(
      fontStyle: FontStyle.italic,
      color: colorScheme.onSurfaceVariant,
    ),
    listBullet: TextStyle(
      color: colorScheme.primary,
      fontWeight: FontWeight.normal,
      fontSize: baseText?.fontSize,
    ),
    listIndent: 16,
    h1: theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: colorScheme.onSurface,
    ),
    h2: theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: colorScheme.onSurface,
    ),
    h3: theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    ),
    tableBorder: TableBorder.all(
      color: colorScheme.outline.withValues(alpha: 0.3),
      width: 1,
    ),
    tableHead: baseText?.copyWith(fontWeight: FontWeight.bold),
    tableBody: baseText,
    tableCellsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  );
}
