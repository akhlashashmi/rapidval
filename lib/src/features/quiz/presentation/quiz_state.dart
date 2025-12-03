import 'package:freezed_annotation/freezed_annotation.dart';
import '../domain/quiz_entity.dart';
import '../domain/user_answer.dart';

part 'quiz_state.freezed.dart';

@freezed
abstract class QuizState with _$QuizState {
  const factory QuizState({
    required Quiz quiz,
    @Default(0) int currentQuestionIndex,
    @Default([]) List<UserAnswer> userAnswers,
    @Default(0) int timeLeft,
    @Default(false) bool isCompleted,
    required DateTime startedAt,
  }) = _QuizState;
}
