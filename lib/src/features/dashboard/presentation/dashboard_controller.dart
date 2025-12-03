import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/quiz_config.dart';
import '../data/dashboard_repository.dart';

part 'dashboard_controller.g.dart';

@Riverpod(keepAlive: true)
class DashboardController extends _$DashboardController {
  @override
  Future<QuizConfig> build() async {
    final prefs = await ref
        .watch(dashboardRepositoryProvider)
        .loadPreferences();
    return prefs ?? const QuizConfig();
  }

  Future<void> setTopic(String topic) async {
    final current = state.value ?? const QuizConfig();
    final newConfig = current.copyWith(topic: topic);
    state = AsyncData(newConfig);
    await _savePreferences(newConfig);
  }

  Future<void> setDifficulty(QuizDifficulty difficulty) async {
    final current = state.value ?? const QuizConfig();
    final newConfig = current.copyWith(difficulty: difficulty);
    state = AsyncData(newConfig);
    await _savePreferences(newConfig);
  }

  Future<void> setQuestionCount(int count) async {
    final current = state.value ?? const QuizConfig();
    final newConfig = current.copyWith(questionCount: count);
    state = AsyncData(newConfig);
    await _savePreferences(newConfig);
  }

  Future<void> setTimePerQuestion(int seconds) async {
    final current = state.value ?? const QuizConfig();
    final newConfig = current.copyWith(timePerQuestionSeconds: seconds);
    state = AsyncData(newConfig);
    await _savePreferences(newConfig);
  }

  Future<void> _savePreferences(QuizConfig config) async {
    await ref.read(dashboardRepositoryProvider).savePreferences(config);
  }
}
