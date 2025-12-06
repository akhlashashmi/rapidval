import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_entity.freezed.dart';
part 'quiz_entity.g.dart';

@freezed
abstract class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required String id,
    required String question,
    required List<String> options,
    required int correctOptionIndex,
    @Default([]) List<int> correctIndices, // For multiple choice
    @Default(QuizQuestionType.single) QuizQuestionType type,
    required String explanation,
    String? hint,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}

enum QuizQuestionType { single, multiple }

@freezed
abstract class Quiz with _$Quiz {
  const factory Quiz({
    required String id,
    required String topic, // Original user input
    required String title, // Generated title
    required String category,
    required List<String> topics, // Generated keywords
    required String difficulty,
    required List<QuizQuestion> questions,
    required DateTime createdAt,
  }) = _Quiz;

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
}
