import 'package:freezed_annotation/freezed_annotation.dart';
import 'quiz_entity.dart';

part 'user_answer.freezed.dart';
part 'user_answer.g.dart';

@freezed
abstract class UserAnswer with _$UserAnswer {
  const factory UserAnswer({
    required int questionIndex,
    required int selectedOptionIndex,
    required DateTime answeredAt,
  }) = _UserAnswer;

  factory UserAnswer.fromJson(Map<String, dynamic> json) =>
      _$UserAnswerFromJson(json);
}

@freezed
abstract class QuizResult with _$QuizResult {
  const factory QuizResult({
    required String quizId,
    required Quiz quiz,
    required List<UserAnswer> answers,
    required DateTime startedAt,
    required DateTime completedAt,
    required int correctAnswers,
    required int totalQuestions,
    required double percentage,
  }) = _QuizResult;

  factory QuizResult.fromJson(Map<String, dynamic> json) =>
      _$QuizResultFromJson(json);
}
