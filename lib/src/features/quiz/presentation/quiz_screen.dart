import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import '../domain/user_answer.dart';
import '../domain/quiz_entity.dart';
import 'quiz_controller.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final bool isReviewMode;
  final QuizResult? quizResult;

  const QuizScreen({super.key, this.isReviewMode = false, this.quizResult});

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
    final quizState = ref.watch(quizControllerProvider);

    // --- Loading / Empty States ---
    if (quizState == null && !widget.isReviewMode) return _buildNoQuizState();
    if (quizState != null && quizState.isCompleted && !widget.isReviewMode) {
      _handleQuizCompletion();
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (widget.isReviewMode && widget.quizResult == null) {
      return _buildErrorState();
    }

    // --- Data Preparation ---
    final quiz = widget.isReviewMode
        ? widget.quizResult!.quiz
        : quizState!.quiz;
    final currentIndex = widget.isReviewMode
        ? _reviewIndex
        : quizState!.currentQuestionIndex;
    final question = quiz.questions[currentIndex];
    final totalQuestions = quiz.questions.length;

    // Logic for selected answer
    final UserAnswer? userAnswer = widget.isReviewMode
        ? widget.quizResult!.answers.firstWhere(
            (a) => a.questionIndex == currentIndex,
            orElse: () => UserAnswer(
              questionIndex: currentIndex,
              selectedOptionIndex: -1,
              answeredAt: DateTime.now(),
            ),
          )
        : ref
              .read(quizControllerProvider.notifier)
              .getAnswerForQuestion(currentIndex);

    final bool isAnswered = widget.isReviewMode ? true : userAnswer != null;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Fixed Header (Progress & Topic)
            _QuizHeader(
              currentIndex: currentIndex,
              totalQuestions: totalQuestions,
              title: quiz.title,
              category: quiz.category,
              timeLeft: widget.isReviewMode ? 0 : quizState!.timeLeft,
              isReviewMode: widget.isReviewMode,
              pulseController: _timerPulseController,
              onClose: () => _handleClose(context),
            ),

            // 2. Scrollable Content (Question & Options)
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                physics: const BouncingScrollPhysics(),
                children: [
                  // Question Section
                  _QuestionDisplay(question: question)
                      .animate(key: ValueKey(currentIndex))
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),

                  const SizedBox(height: 32),

                  // Options Section
                  Text(
                    'Select an answer:',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 16),

                  ...List.generate(question.options.length, (index) {
                    final isSelected = userAnswer?.selectedOptionIndex == index;
                    final isCorrect = question.correctOptionIndex == index;

                    // Interaction Logic
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
                          // In review mode, show if it is correct OR if it was the user's wrong selection
                          isCorrectContext: widget.isReviewMode
                              ? isCorrect
                              : null,
                          isWrongContext: widget.isReviewMode
                              ? (isSelected && !isCorrect)
                              : null,
                          onTap: onTap,
                        )
                        .animate(key: ValueKey('${currentIndex}_$index'))
                        .fadeIn(
                          delay: Duration(milliseconds: 100 + (index * 50)),
                        )
                        .slideX(begin: 0.05, end: 0);
                  }),

                  // Explanation (Review Mode Only)
                  if (widget.isReviewMode) ...[
                    const SizedBox(height: 24),
                    _ExplanationCard(explanation: question.explanation)
                        .animate()
                        .fadeIn(delay: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 80), // Bottom padding for FAB
                  ],
                ],
              ),
            ),

            // 3. Fixed Bottom Action Bar
            _BottomActionBar(
              isReviewMode: widget.isReviewMode,
              isAnswered: isAnswered,
              isLastQuestion: currentIndex == totalQuestions - 1,
              canGoBack: currentIndex > 0,
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
                setState(() => _reviewIndex--);
                _scrollToTop();
              },
              onCloseReview: () => Navigator.pop(context),
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
        context.pushReplacement('/results', extra: result);
      });
    }
  }

  void _handleClose(BuildContext context) {
    if (widget.isReviewMode) {
      Navigator.pop(context);
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
                context.go('/dashboard');
              },
              child: const Text('Exit'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildNoQuizState() =>
      const Scaffold(body: Center(child: Text("No Active Quiz")));
  Widget _buildErrorState() =>
      const Scaffold(body: Center(child: Text("Error loading results")));
}

// SUB-WIDGETS

class _QuizHeader extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final String title;
  final String category;
  final int timeLeft;
  final bool isReviewMode;
  final AnimationController pulseController;
  final VoidCallback onClose;

  const _QuizHeader({
    required this.currentIndex,
    required this.totalQuestions,
    required this.title,
    required this.category,
    required this.timeLeft,
    required this.isReviewMode,
    required this.pulseController,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentIndex + 1) / totalQuestions;
    final isLowTime = timeLeft <= 10;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton.filledTonal(
                onPressed: onClose,
                icon: const Icon(Icons.close, size: 20),
                style: IconButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Question ${currentIndex + 1} of $totalQuestions',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isReviewMode)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isLowTime
                        ? Colors.red.withValues(alpha: 0.1)
                        : Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isLowTime ? Colors.red : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      AnimatedBuilder(
                        animation: pulseController,
                        builder: (context, child) => Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: isLowTime
                              ? Colors.red.withValues(
                                  alpha: 0.6 + (pulseController.value * 0.4),
                                )
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatTime(timeLeft),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          color: isLowTime
                              ? Colors.red
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds / 60).floor();
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _QuestionDisplay extends StatelessWidget {
  final QuizQuestion question;

  const _QuestionDisplay({required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'QUESTION',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
            if (question.hint != null)
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Hint: ${question.hint}'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.lightbulb_outline, size: 16),
                label: const Text('Show Hint'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        MarkdownBody(
          data: question.question,
          selectable: true,
          styleSheet: _buildProfessionalMarkdownStyle(
            context,
            isQuestion: true,
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
  final bool? isCorrectContext;
  final bool? isWrongContext;
  final VoidCallback? onTap;

  const _OptionTile({
    required this.text,
    required this.index,
    required this.isSelected,
    this.isCorrectContext,
    this.isWrongContext,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final letters = ['A', 'B', 'C', 'D', 'E', 'F'];

    Color borderColor = theme.colorScheme.outline.withValues(alpha: 0.2);
    Color backgroundColor = theme.colorScheme.surface;
    Color letterBg = theme.colorScheme.surfaceContainerHighest;
    Color letterColor = theme.colorScheme.onSurface;

    if (isCorrectContext == true) {
      borderColor = Colors.green;
      backgroundColor = Colors.green.withValues(alpha: 0.05);
      letterBg = Colors.green;
      letterColor = Colors.white;
    } else if (isWrongContext == true) {
      borderColor = Colors.red;
      backgroundColor = Colors.red.withValues(alpha: 0.05);
      letterBg = Colors.red;
      letterColor = Colors.white;
    } else if (isSelected) {
      borderColor = theme.colorScheme.primary;
      backgroundColor = theme.colorScheme.primaryContainer.withValues(
        alpha: 0.2,
      );
      letterBg = theme.colorScheme.primary;
      letterColor = theme.colorScheme.onPrimary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: isSelected || isCorrectContext == true ? 2 : 1,
            ),
            boxShadow: isSelected && isCorrectContext == null
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: letterBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: isCorrectContext == true
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : isWrongContext == true
                    ? const Icon(Icons.close, size: 16, color: Colors.white)
                    : Text(
                        letters[index % letters.length],
                        style: TextStyle(
                          color: letterColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
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

class _BottomActionBar extends StatelessWidget {
  final bool isReviewMode;
  final bool isAnswered;
  final bool isLastQuestion;
  final bool canGoBack;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onCloseReview;

  const _BottomActionBar({
    required this.isReviewMode,
    required this.isAnswered,
    required this.isLastQuestion,
    required this.canGoBack,
    required this.onNext,
    required this.onPrevious,
    required this.onCloseReview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: isReviewMode
            ? LayoutBuilder(
                builder: (context, constraints) {
                  final halfWidth = (constraints.maxWidth - 16) / 2;
                  return Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: canGoBack ? halfWidth : 0,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: SizedBox(
                            width: halfWidth,
                            child: OutlinedButton.icon(
                              onPressed: onPrevious,
                              icon: const Icon(Icons.arrow_back),
                              label: const Text('Previous'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline.withValues(alpha: 0.2),
                                ),
                                shape: const StadiumBorder(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: canGoBack ? 16 : 0,
                      ),
                      Expanded(
                        child: isLastQuestion
                            ? FilledButton.icon(
                                onPressed: onCloseReview,
                                icon: const Icon(Icons.check),
                                label: const Text('Close Review'),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: const StadiumBorder(),
                                ),
                              )
                            : FilledButton.icon(
                                onPressed: onNext,
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('Next'),
                                iconAlignment: IconAlignment.end,
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: const StadiumBorder(),
                                ),
                              ),
                      ),
                    ],
                  );
                },
              )
            : SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isAnswered ? onNext : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const StadiumBorder(),
                    elevation: isAnswered ? 2 : 0,
                  ),
                  child: const Text(
                    'Next Question',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// HELPER: Professional Markdown Styling
// -----------------------------------------------------------------------------

MarkdownStyleSheet _buildProfessionalMarkdownStyle(
  BuildContext context, {
  required bool isQuestion,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  final double pSize = isQuestion ? 16.0 : 15.0;
  final double codeSize = isQuestion ? 14.0 : 13.0;

  return MarkdownStyleSheet(
    p: theme.textTheme.bodyLarge?.copyWith(
      fontSize: pSize,
      height: 1.6,
      color: colorScheme.onSurface,
    ),
    strong: theme.textTheme.bodyLarge?.copyWith(
      fontSize: pSize,
      fontWeight: FontWeight.w700,
      color: colorScheme.onSurface,
    ),
    codeblockDecoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
    ),
    codeblockPadding: const EdgeInsets.all(16),
    code: TextStyle(
      fontFamily: 'monospace',
      backgroundColor: colorScheme.surfaceContainerHighest,
      color: colorScheme.primary,
      fontSize: codeSize,
      fontWeight: FontWeight.w500,
    ),
    pPadding: EdgeInsets.zero,
    blockquoteDecoration: BoxDecoration(
      color: colorScheme.secondaryContainer.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(4),
      border: Border(left: BorderSide(color: colorScheme.secondary, width: 4)),
    ),
    blockquotePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    blockquote: theme.textTheme.bodyMedium?.copyWith(
      fontStyle: FontStyle.italic,
      color: colorScheme.onSurfaceVariant,
    ),
    listBullet: TextStyle(
      color: colorScheme.primary,
      fontWeight: FontWeight.bold,
    ),
    tableBorder: TableBorder.all(
      color: colorScheme.outline.withValues(alpha: 0.2),
      width: 1,
    ),
    tableHead: theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.bold,
    ),
    tableBody: theme.textTheme.bodyMedium,
  );
}
