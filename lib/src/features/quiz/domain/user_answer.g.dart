// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserAnswer _$UserAnswerFromJson(Map<String, dynamic> json) => _UserAnswer(
  questionIndex: (json['questionIndex'] as num).toInt(),
  selectedOptionIndex: (json['selectedOptionIndex'] as num).toInt(),
  selectedIndices:
      (json['selectedIndices'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  answeredAt: DateTime.parse(json['answeredAt'] as String),
);

Map<String, dynamic> _$UserAnswerToJson(_UserAnswer instance) =>
    <String, dynamic>{
      'questionIndex': instance.questionIndex,
      'selectedOptionIndex': instance.selectedOptionIndex,
      'selectedIndices': instance.selectedIndices,
      'answeredAt': instance.answeredAt.toIso8601String(),
    };

_QuizResult _$QuizResultFromJson(Map<String, dynamic> json) => _QuizResult(
  quizId: json['quizId'] as String,
  quiz: Quiz.fromJson(json['quiz'] as Map<String, dynamic>),
  answers: (json['answers'] as List<dynamic>)
      .map((e) => UserAnswer.fromJson(e as Map<String, dynamic>))
      .toList(),
  startedAt: DateTime.parse(json['startedAt'] as String),
  completedAt: DateTime.parse(json['completedAt'] as String),
  correctAnswers: (json['correctAnswers'] as num).toInt(),
  totalQuestions: (json['totalQuestions'] as num).toInt(),
  percentage: (json['percentage'] as num).toDouble(),
);

Map<String, dynamic> _$QuizResultToJson(_QuizResult instance) =>
    <String, dynamic>{
      'quizId': instance.quizId,
      'quiz': instance.quiz,
      'answers': instance.answers,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt.toIso8601String(),
      'correctAnswers': instance.correctAnswers,
      'totalQuestions': instance.totalQuestions,
      'percentage': instance.percentage,
    };
