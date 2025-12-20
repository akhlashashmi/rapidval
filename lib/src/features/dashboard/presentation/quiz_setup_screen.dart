import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';

import 'dashboard_controller.dart';
import '../../quiz/domain/quiz_entity.dart';
import '../../quiz/presentation/quiz_controller.dart';
import '../../../core/widgets/app_button.dart';

class QuizSetupScreen extends ConsumerStatefulWidget {
  final Quiz quiz;

  const QuizSetupScreen({super.key, required this.quiz});

  @override
  ConsumerState<QuizSetupScreen> createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends ConsumerState<QuizSetupScreen> {
  late int _timePerQuestion;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Default to the user's preference or 15 seconds
    _timePerQuestion =
        ref.read(dashboardControllerProvider).value?.timePerQuestionSeconds ??
        15;
  }

  void _startQuiz() {
    setState(() => _isLoading = true);

    // Slight delay to allow UI to update and ensure smooth transition
    Future.microtask(() {
      try {
        ref
            .read(quizControllerProvider.notifier)
            .startQuiz(widget.quiz, _timePerQuestion);

        if (mounted) {
          context.pushReplacement('/quiz');
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to start quiz: $e'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
          'Get Ready',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Quiz Summary Section
                  Text(
                    'Quiz Details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ).animate().fadeIn().slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 400.ms,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.quiz.questions.length > 5
                                ? FontAwesomeIcons.bookOpen
                                : FontAwesomeIcons.bolt,
                            size: 32,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.quiz.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.quiz.category.toUpperCase(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            letterSpacing: 1.2,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Divider(
                          color: colorScheme.outline.withValues(alpha: 0.1),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _CompactStat(
                              icon: Icons.signal_cellular_alt_rounded,
                              label: 'Difficulty',
                              value: widget.quiz.difficulty.toUpperCase(),
                            ),
                            _CompactStat(
                              icon: Icons.format_list_numbered_rounded,
                              label: 'Questions',
                              value: '${widget.quiz.questions.length}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),

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
                      color: colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionLabel(
                          label: 'Time per Question',
                          icon: Icons.timer_rounded,
                        ),
                        const SizedBox(height: 8),
                        _SliderSetting(
                          value: '$_timePerQuestion sec',
                          min: 5,
                          max: 60,
                          divisions: 11,
                          currentValue: _timePerQuestion.toDouble(),
                          onChanged: _isLoading
                              ? null
                              : (v) => setState(
                                  () => _timePerQuestion = v.toInt(),
                                ),
                          enabled: !_isLoading,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
                ],
              ),
            ),
          ),

          // Bottom Action Button
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: SafeArea(
              child: AppButton(
                onPressed: _isLoading ? null : _startQuiz,
                text: 'Start Quiz',
                isLoading: _isLoading,
                icon: const Icon(Icons.play_arrow_rounded, size: 24),
              ),
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 1, end: 0),
        ],
      ),
    );
  }
}

class _CompactStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CompactStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
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

class _SliderSetting extends StatelessWidget {
  final String value;
  final double min;
  final double max;
  final int divisions;
  final double currentValue;
  final ValueChanged<double>? onChanged;
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
                  onChanged: onChanged,
                ),
              ),
            ),
            Container(
              width: 70,
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
