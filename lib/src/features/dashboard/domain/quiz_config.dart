import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_config.freezed.dart';

enum QuizDifficulty { beginner, intermediate, advanced }

@freezed
abstract class QuizConfig with _$QuizConfig {
  const factory QuizConfig({
    @Default('') String topic,
    @Default(QuizDifficulty.intermediate) QuizDifficulty difficulty,
    @Default(5) int questionCount,
    @Default(15) int timePerQuestionSeconds, // Timer per question
  }) = _QuizConfig;
}