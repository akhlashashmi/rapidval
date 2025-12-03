import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../domain/user_answer.dart';
import '../domain/quiz_entity.dart';
import 'quiz_screen.dart';
import 'dart:math' as math;

class ResultsScreen extends StatefulWidget {
  final QuizResult quizResult;

  const ResultsScreen({super.key, required this.quizResult});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    if (widget.quizResult.percentage >= 70) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _showConfetti = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.quizResult;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    colorScheme.surface,
                  ],
                ),
              ),
            ),
          ),

          if (_showConfetti)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: ParticlePainter()),
              ),
            ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // 1. Result Header Card
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: _ResultSummaryCard(result: result)
                              .animate()
                              .scale(
                                duration: 500.ms,
                                curve: Curves.easeOutBack,
                              )
                              .fadeIn(),
                        ),

                        // 2. Section Title
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Detailed Breakdown',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface.withOpacity(
                                        0.6,
                                      ),
                                      letterSpacing: 1,
                                    ),
                              ),
                              const Spacer(),
                              Text(
                                '${result.correctAnswers}/${result.totalQuestions} Correct',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: colorScheme.primary),
                              ),
                            ],
                          ),
                        ),

                        // 3. Questions List
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          itemCount: result.quiz.questions.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final question = result.quiz.questions[index];
                            final userAnswer = result.answers.firstWhere(
                              (a) => a.questionIndex == index,
                              orElse: () => UserAnswer(
                                questionIndex: index,
                                selectedOptionIndex: -1,
                                answeredAt: DateTime.now(),
                              ),
                            );

                            return _QuestionResultTile(
                                  index: index,
                                  question: question,
                                  userSelectedOptionIndex:
                                      userAnswer.selectedOptionIndex,
                                  isCorrect:
                                      userAnswer.selectedOptionIndex ==
                                      question.correctOptionIndex,
                                  isSkipped:
                                      userAnswer.selectedOptionIndex == -1,
                                )
                                .animate()
                                .fadeIn(
                                  delay: Duration(
                                    milliseconds: 100 + (index * 30),
                                  ),
                                )
                                .slideY(begin: 0.1, end: 0);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // 4. Anchored Bottom Action Dock
                _ActionDock(
                  onReview: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuizScreen(isReviewMode: true, quizResult: result),
                      ),
                    );
                  },
                  onRetake: () =>
                      context.push('/create-quiz', extra: result.quiz),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SUB-WIDGETS
// -----------------------------------------------------------------------------

class _ResultSummaryCard extends StatelessWidget {
  final QuizResult result;

  const _ResultSummaryCard({required this.result});

  Color _getScoreColor() {
    if (result.percentage >= 80) return const Color(0xFF22C55E);
    if (result.percentage >= 60) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  String _getMessage() {
    if (result.percentage >= 90) return 'Outstanding Performance!';
    if (result.percentage >= 80) return 'Great Job!';
    if (result.percentage >= 60) return 'Good Effort';
    return 'Keep Practicing';
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = _getScoreColor();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: scoreColor.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: 1.0,
                      color: theme.colorScheme.surfaceContainerHighest,
                      strokeWidth: 4,
                    ),
                    CircularProgressIndicator(
                      value: result.percentage / 100,
                      color: scoreColor,
                      strokeWidth: 4,
                      strokeCap: StrokeCap.round,
                    ),
                    Text(
                      '${result.percentage.toInt()}%',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: scoreColor,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getMessage(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'You completed the quiz in ${_formatDuration(result.completedAt.difference(result.startedAt))}.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    if (d.inMinutes > 0) return '${d.inMinutes}m ${d.inSeconds % 60}s';
    return '${d.inSeconds}s';
  }
}

class _QuestionResultTile extends StatelessWidget {
  final int index;
  final QuizQuestion question;
  final int userSelectedOptionIndex;
  final bool isCorrect;
  final bool isSkipped;

  const _QuestionResultTile({
    required this.index,
    required this.question,
    required this.userSelectedOptionIndex,
    required this.isCorrect,
    required this.isSkipped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color statusColor;
    IconData statusIcon;

    if (isSkipped) {
      statusColor = Colors.grey;
      statusIcon = Icons.remove_circle_outline;
    } else if (isCorrect) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${index + 1}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  question.question.replaceAll(RegExp(r'[\#\*]'), ''),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                if (!isCorrect && !isSkipped)
                  Text(
                    'Correct: ${question.options[question.correctOptionIndex]}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
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

class _ActionDock extends StatelessWidget {
  final VoidCallback onReview;
  final VoidCallback onRetake;

  const _ActionDock({required this.onReview, required this.onRetake});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onReview,
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Review'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
                shape: const StadiumBorder(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FilledButton.icon(
              onPressed: onRetake,
              icon: const Icon(Icons.refresh),
              label: const Text('Retake Quiz'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const StadiumBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles = List.generate(50, (i) => Particle());

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()..color = p.color;
      canvas.drawCircle(
        Offset(size.width * p.x, size.height * p.y),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Particle {
  final double x = math.Random().nextDouble();
  final double y = math.Random().nextDouble() * 0.5;
  final double size = math.Random().nextDouble() * 4 + 2;
  final Color color = Color.fromRGBO(
    math.Random().nextInt(255),
    math.Random().nextInt(255),
    math.Random().nextInt(255),
    0.6,
  );
}
