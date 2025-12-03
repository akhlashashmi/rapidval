import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
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
            if (!mounted) return;
            _generationSubscription?.cancel();
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error generating quiz: $e'),
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
        leading: IconButton(
          onPressed: _isLoading ? null : () => context.pop(),
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
        ),
        title: Text(
          isRetake ? 'Retake Quiz' : 'Create New Quiz',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
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
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Topic Input
                          Text(
                            'Topic',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _topicController,
                            onChanged: controller.setTopic,
                            enabled: !isRetake && !_isLoading,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              hintText: 'What do you want to learn?',
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: colorScheme.primary,
                              ),
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest
                                  .withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colorScheme.primary,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Configuration Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest
                                  .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: colorScheme.outline.withOpacity(0.1),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Difficulty
                                Text(
                                  'Difficulty Level',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _DifficultyOption(
                                        label: 'Easy',
                                        value: QuizDifficulty.beginner,
                                        groupValue: config.difficulty,
                                        onChanged: (v) =>
                                            controller.setDifficulty(v),
                                        color: Colors.green,
                                        enabled: !isRetake && !_isLoading,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _DifficultyOption(
                                        label: 'Medium',
                                        value: QuizDifficulty.intermediate,
                                        groupValue: config.difficulty,
                                        onChanged: (v) =>
                                            controller.setDifficulty(v),
                                        color: Colors.orange,
                                        enabled: !isRetake && !_isLoading,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _DifficultyOption(
                                        label: 'Hard',
                                        value: QuizDifficulty.advanced,
                                        groupValue: config.difficulty,
                                        onChanged: (v) =>
                                            controller.setDifficulty(v),
                                        color: Colors.red,
                                        enabled: !isRetake && !_isLoading,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Divider(
                                  color: colorScheme.outline.withOpacity(0.1),
                                ),
                                const SizedBox(height: 24),

                                // Question Count
                                _SliderSetting(
                                  label: 'Number of Questions',
                                  value: config.questionCount.toString(),
                                  min: 3,
                                  max: 20,
                                  divisions: 17,
                                  currentValue: config.questionCount.toDouble(),
                                  onChanged: (v) =>
                                      controller.setQuestionCount(v.toInt()),
                                  enabled: !isRetake && !_isLoading,
                                ),
                                const SizedBox(height: 24),

                                // Time
                                _SliderSetting(
                                  label: 'Time per Question',
                                  value: '${config.timePerQuestionSeconds}s',
                                  min: 5,
                                  max: 60,
                                  divisions: 11,
                                  currentValue: config.timePerQuestionSeconds
                                      .toDouble(),
                                  onChanged: (v) =>
                                      controller.setTimePerQuestion(v.toInt()),
                                  enabled: !_isLoading,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Button
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: colorScheme.surface),
                    child: SafeArea(
                      child: FilledButton(
                        onPressed: _isLoading || config.topic.isEmpty
                            ? null
                            : _startQuiz,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isRetake
                                  ? Icons.refresh_rounded
                                  : Icons.play_arrow_rounded,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isRetake ? 'Retake Quiz' : 'Start Quiz',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Loading Overlay
              if (_isLoading)
                Positioned.fill(
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: colorScheme.surface.withOpacity(0.8),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Progress Circle
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    height: 80,
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
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Text Info
                              Text(
                                'Generating Quiz...',
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
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
                              OutlinedButton.icon(
                                onPressed: _cancelGeneration,
                                icon: const Icon(Icons.close_rounded),
                                label: const Text('Cancel Generation'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: colorScheme.error,
                                  side: BorderSide(color: colorScheme.error),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? color : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _SliderSetting extends StatelessWidget {
  final String label;
  final String value;
  final double min;
  final double max;
  final int divisions;
  final double currentValue;
  final ValueChanged<double> onChanged;
  final bool enabled;

  const _SliderSetting({
    required this.label,
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

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: colorScheme.primary,
              inactiveTrackColor: colorScheme.primary.withOpacity(0.1),
              thumbColor: colorScheme.primary,
              overlayColor: colorScheme.primary.withOpacity(0.1),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: currentValue,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ],
      ),
    );
  }
}
