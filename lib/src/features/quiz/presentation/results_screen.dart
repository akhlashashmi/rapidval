import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../domain/user_answer.dart';
import '../domain/quiz_entity.dart';
import 'quiz_screen.dart';

class ResultsScreen extends StatefulWidget {
  final QuizResult quizResult;

  const ResultsScreen({super.key, required this.quizResult});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final GlobalKey _globalKey = GlobalKey();

  Future<void> _captureAndSharePng() async {
    try {
      // Find the render boundary
      final boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      // Convert to image
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes == null) return;

      // Save to temporary file
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/quiz_result.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(pngBytes);

      // Share
      final result = widget.quizResult;
      final text =
          'I just scored ${result.percentage.toInt()}% on the ${result.quiz.title} quiz in RapidVal! 🚀\n\nCan you beat my score? Download the app now: https://play.google.com/store/apps/details?id=com.akhlashashmi.rapidval';

      await Share.shareXFiles([XFile(imagePath)], text: text);
    } catch (e) {
      debugPrint('Error sharing: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to share results')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.quizResult;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: theme.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
        title:
            Text(
                  'Quiz Summary',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                    letterSpacing: 0.5,
                  ),
                )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.5, end: 0, duration: 400.ms),
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: IconButton(
            onPressed: () => context.go('/dashboard'),
            icon: const Icon(Icons.close, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
              foregroundColor: colorScheme.onSurface,
              side: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.1),
              ),
              elevation: 0,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: IconButton(
              onPressed: _captureAndSharePng,
              icon: const Icon(Icons.ios_share_rounded, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
                foregroundColor: colorScheme.onSurface,
                side: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Hidden Shareable Card (Rendered behind main content)
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: RepaintBoundary(
                key: _globalKey,
                child: _ShareableResultCard(result: result),
              ),
            ),
          ),
          // Main Content with background to cover the hidden card
          Container(
            color: colorScheme.surface,
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).padding.top + 70,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _ResultSummaryCard(result: result)
                                .animate()
                                .slideY(
                                  begin: 0.1,
                                  end: 0,
                                  duration: 600.ms,
                                  curve: Curves.easeOutBack,
                                )
                                .fadeIn(duration: 400.ms),
                          ),
                          const SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: [
                                Text(
                                  'Detailed Breakdown',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                                    letterSpacing: 1,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer
                                        .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${result.correctAnswers}/${result.totalQuestions} Correct',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            itemCount: result.quiz.questions.length,
                            separatorBuilder: (context, index) =>
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
                                      milliseconds: 200 + (index * 50),
                                    ),
                                    duration: 400.ms,
                                  )
                                  .slideX(
                                    begin: 0.1,
                                    end: 0,
                                    delay: Duration(
                                      milliseconds: 200 + (index * 50),
                                    ),
                                    curve: Curves.easeOutCubic,
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  _ActionDock(
                        onReview: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                isReviewMode: true,
                                quizResult: result,
                              ),
                            ),
                          );
                        },
                        onRetake: () =>
                            context.push('/create-quiz', extra: result.quiz),
                      )
                      .animate()
                      .fadeIn(delay: 600.ms)
                      .slideY(begin: 1, end: 0, curve: Curves.easeOutCubic),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultSummaryCard extends StatelessWidget {
  final QuizResult result;

  const _ResultSummaryCard({required this.result});

  Color _getScoreColor() {
    if (result.percentage >= 80) return const Color(0xFF22C55E);
    if (result.percentage >= 60) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  String _getMessage() {
    if (result.percentage >= 90) return 'Outstanding!';
    if (result.percentage >= 80) return 'Great Job!';
    if (result.percentage >= 60) return 'Good Effort';
    return 'Keep Practicing';
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = _getScoreColor();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getMessage(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You completed the quiz in ${_formatDuration(result.completedAt.difference(result.startedAt))}.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: 1.0,
                        color: scoreColor.withValues(alpha: 0.1),
                        strokeWidth: 8,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: result.percentage / 100),
                      duration: 1500.ms,
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) => SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: value,
                          color: scoreColor,
                          strokeWidth: 8,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: result.percentage),
                      duration: 1500.ms,
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${value.toInt()}%',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: scoreColor,
                            ),
                          ),
                        ],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 16),
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
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                if (!isCorrect && !isSkipped) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: Color(0xFF22C55E),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            question.options[question.correctOptionIndex],
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF15803D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onReview,
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Review Answers'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                foregroundColor: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FilledButton.icon(
              onPressed: onRetake,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retake Quiz'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareableResultCard extends StatelessWidget {
  final QuizResult result;

  const _ShareableResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 400,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school_rounded, color: colorScheme.primary, size: 32),
              const SizedBox(width: 12),
              Text(
                'RapidVal',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            result.quiz.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: result.percentage / 100,
                  strokeWidth: 16,
                  strokeCap: StrokeCap.round,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  color: _getScoreColor(result.percentage),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${result.percentage.toInt()}%',
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: _getScoreColor(result.percentage),
                    ),
                  ),
                  Text(
                    'Score',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${result.correctAnswers} out of ${result.totalQuestions} Correct',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Can you beat my score?',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get RapidVal on Play Store',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return const Color(0xFF22C55E);
    if (percentage >= 60) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }
}
