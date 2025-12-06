import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../domain/quiz_config.dart';
import 'dashboard_controller.dart';
import '../../quiz/data/quiz_repository.dart';
import '../../quiz/domain/quiz_entity.dart';
import '../../quiz/presentation/quiz_controller.dart';

class CreateQuizScreen extends ConsumerStatefulWidget {
  final Quiz? existingQuiz;

  const CreateQuizScreen({super.key, this.existingQuiz});

  @override
  ConsumerState<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends ConsumerState<CreateQuizScreen> {
  final TextEditingController _topicController = TextEditingController();
  bool _isLoading = false;
  double _progress = 0.0;
  StreamSubscription? _generationSubscription;

  @override
  void initState() {
    super.initState();
    if (widget.existingQuiz != null) {
      _topicController.text = widget.existingQuiz!.topic;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final controller = ref.read(dashboardControllerProvider.notifier);
        controller.setTopic(widget.existingQuiz!.topic);
        controller.setQuestionCount(widget.existingQuiz!.questions.length);
        try {
          final diff = QuizDifficulty.values.firstWhere(
            (e) => e.name == widget.existingQuiz!.difficulty,
          );
          controller.setDifficulty(diff);
        } catch (_) {}
      });
    } else {
      final config = ref.read(dashboardControllerProvider).value;
      if (config != null && config.topic.isNotEmpty) {
        _topicController.text = config.topic;
      }
    }
  }

  @override
  void dispose() {
    _topicController.dispose();
    _generationSubscription?.cancel();
    super.dispose();
  }

  void _cancelGeneration() {
    _generationSubscription?.cancel();
    if (mounted) {
      setState(() {
        _isLoading = false;
        _progress = 0.0;
      });
    }
  }

  Future<void> _startQuiz() async {
    final configState = ref.read(dashboardControllerProvider);
    final config = configState.value;

    if (config == null) return;

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _isLoading = true;
      _progress = 0.0;
    });

    if (widget.existingQuiz != null) {
      try {
        final quiz = widget.existingQuiz!;
        if (!mounted) return;
        ref
            .read(quizControllerProvider.notifier)
            .startQuiz(quiz, config.timePerQuestionSeconds);
        // Replace current screen with quiz
        context.pushReplacement('/quiz');
      } catch (e) {
        log('Error starting existing quiz: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong. Please try again.'),
            ),
          );
          setState(() => _isLoading = false);
        }
      }
      return;
    }

    // Start Stream
    _generationSubscription?.cancel();
    _generationSubscription = ref
        .read(quizRepositoryProvider)
        .generateQuizStream(config)
        .listen(
          (event) {
            if (!mounted) return;
            setState(() => _progress = event.$1);

            if (event.$2 != null) {
              // Success
              _generationSubscription?.cancel();
              ref
                  .read(quizControllerProvider.notifier)
                  .startQuiz(event.$2!, config.timePerQuestionSeconds);
              // Replace current screen with quiz
              context.pushReplacement('/quiz');
            }
          },
          onError: (e) {
            log('Error generating quiz: $e');
            if (!mounted) return;
            _generationSubscription?.cancel();
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Something went wrong. Please try again.'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(dashboardControllerProvider);
    final controller = ref.read(dashboardControllerProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isRetake = widget.existingQuiz != null;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: _isLoading ? null : () => context.pop(),
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
        ),
        title: Text(
          isRetake ? 'Retake Quiz' : 'New Quiz',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: configAsync.when(
        data: (config) => PopScope(
          canPop: !_isLoading,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Topic Input Section
                          Text(
                            'What would you like to learn?',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ).animate().fadeIn().slideY(
                            begin: 0.2,
                            end: 0,
                            duration: 400.ms,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                                controller: _topicController,
                                onChanged: controller.setTopic,
                                enabled: !isRetake && !_isLoading,
                                style: theme.textTheme.bodyLarge,
                                decoration: InputDecoration(
                                  hintText: 'e.g., Quantum Physics, Flutter...',
                                  hintStyle: TextStyle(
                                    color: colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.5),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    color: colorScheme.primary,
                                  ),
                                  filled: true,
                                  fillColor: colorScheme.surfaceContainerHighest
                                      .withValues(alpha: 0.3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(20),
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 100.ms)
                              .slideY(begin: 0.2, end: 0, duration: 400.ms),
                          const SizedBox(height: 32),

                          // Configuration Section
                          Text(
                            'Configuration',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ).animate().fadeIn(delay: 200.ms),
                          const SizedBox(height: 16),

                          Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.12,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Difficulty
                                    _SectionLabel(
                                      label: 'Difficulty',
                                      icon: Icons.signal_cellular_alt_rounded,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _DifficultyOption(
                                            label: 'Beginner',
                                            value: QuizDifficulty.beginner,
                                            groupValue: config.difficulty,
                                            onChanged: (v) =>
                                                controller.setDifficulty(v),
                                            color: const Color(0xFF22C55E),
                                            enabled: !isRetake && !_isLoading,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _DifficultyOption(
                                            label: 'Intermediate',
                                            value: QuizDifficulty.intermediate,
                                            groupValue: config.difficulty,
                                            onChanged: (v) =>
                                                controller.setDifficulty(v),
                                            color: const Color(0xFFF59E0B),
                                            enabled: !isRetake && !_isLoading,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _DifficultyOption(
                                            label: 'Advanced',
                                            value: QuizDifficulty.advanced,
                                            groupValue: config.difficulty,
                                            onChanged: (v) =>
                                                controller.setDifficulty(v),
                                            color: const Color(0xFFEF4444),
                                            enabled: !isRetake && !_isLoading,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    Divider(
                                      color: colorScheme.outline.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // Question Count
                                    _SectionLabel(
                                      label: 'Questions',
                                      icon: Icons.format_list_numbered_rounded,
                                    ),
                                    const SizedBox(height: 8),
                                    _SliderSetting(
                                      value: '${config.questionCount}',
                                      min: 3,
                                      max: 20,
                                      divisions: 17,
                                      currentValue: config.questionCount
                                          .toDouble(),
                                      onChanged: (v) => controller
                                          .setQuestionCount(v.toInt()),
                                      enabled: !isRetake && !_isLoading,
                                    ),
                                    const SizedBox(height: 24),

                                    // Time
                                    _SectionLabel(
                                      label: 'Time per Question',
                                      icon: Icons.timer_rounded,
                                    ),
                                    const SizedBox(height: 8),
                                    _SliderSetting(
                                      value:
                                          '${config.timePerQuestionSeconds} sec',
                                      min: 5,
                                      max: 60,
                                      divisions: 11,
                                      currentValue: config
                                          .timePerQuestionSeconds
                                          .toDouble(),
                                      onChanged: (v) => controller
                                          .setTimePerQuestion(v.toInt()),
                                      enabled: !_isLoading,
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 300.ms)
                              .slideY(begin: 0.1, end: 0, duration: 400.ms),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Action Button
                  Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          border: Border(
                            top: BorderSide(
                              color: colorScheme.outlineVariant.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                        ),
                        child: SafeArea(
                          child: FilledButton(
                            onPressed: _isLoading || config.topic.isEmpty
                                ? null
                                : _startQuiz,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: const StadiumBorder(),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isRetake
                                      ? Icons.refresh_rounded
                                      : Icons.auto_awesome_rounded,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isRetake ? 'Retake Quiz' : 'Generate Quiz',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .slideY(begin: 1, end: 0, duration: 400.ms),
                ],
              ),

              // Loading Overlay
              if (_isLoading)
                Positioned.fill(
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: colorScheme.surface.withValues(alpha: 0.8),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Progress Circle
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: CircularProgressIndicator(
                                      value: _progress > 0 ? _progress : null,
                                      strokeWidth: 8,
                                      strokeCap: StrokeCap.round,
                                      backgroundColor:
                                          colorScheme.surfaceContainerHighest,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    '${(_progress * 100).toInt()}%',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Text Info
                              Text(
                                'Crafting your quiz...',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (_progress > 0)
                                Text(
                                  '${(config.questionCount * _progress).toInt()} of ${config.questionCount} questions ready',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),

                              const SizedBox(height: 48),

                              // Cancel Button
                              TextButton.icon(
                                onPressed: _cancelGeneration,
                                icon: const Icon(Icons.close_rounded),
                                label: const Text('Cancel'),
                                style: TextButton.styleFrom(
                                  foregroundColor: colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _DifficultyOption extends StatelessWidget {
  final String label;
  final QuizDifficulty value;
  final QuizDifficulty groupValue;
  final ValueChanged<QuizDifficulty> onChanged;
  final Color color;
  final bool enabled;

  const _DifficultyOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.color,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: enabled ? () => onChanged(value) : null,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? color
                : colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _getIconForDifficulty(value),
              color: isSelected ? color : colorScheme.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForDifficulty(QuizDifficulty difficulty) {
    switch (difficulty) {
      case QuizDifficulty.beginner:
        return Icons.sentiment_satisfied_rounded;
      case QuizDifficulty.intermediate:
        return Icons.sentiment_neutral_rounded;
      case QuizDifficulty.advanced:
        return Icons.sentiment_very_dissatisfied_rounded;
    }
  }
}

class _SliderSetting extends StatelessWidget {
  final String value;
  final double min;
  final double max;
  final int divisions;
  final double currentValue;
  final ValueChanged<double> onChanged;
  final bool enabled;

  const _SliderSetting({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.currentValue,
    required this.onChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: colorScheme.primary,
                  inactiveTrackColor: colorScheme.primary.withValues(
                    alpha: 0.1,
                  ),
                  thumbColor: colorScheme.primary,
                  overlayColor: colorScheme.primary.withValues(alpha: 0.1),
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 20,
                  ),
                ),
                child: Slider(
                  value: currentValue,
                  min: min,
                  max: max,
                  divisions: divisions,
                  onChanged: enabled ? onChanged : null,
                ),
              ),
            ),
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
