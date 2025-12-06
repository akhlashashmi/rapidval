// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) =>
    _QuizQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      correctOptionIndex: (json['correctOptionIndex'] as num).toInt(),
      correctIndices:
          (json['correctIndices'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      type:
          $enumDecodeNullable(_$QuizQuestionTypeEnumMap, json['type']) ??
          QuizQuestionType.single,
      explanation: json['explanation'] as String,
      hint: json['hint'] as String?,
    );

Map<String, dynamic> _$QuizQuestionToJson(_QuizQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'options': instance.options,
      'correctOptionIndex': instance.correctOptionIndex,
      'correctIndices': instance.correctIndices,
      'type': _$QuizQuestionTypeEnumMap[instance.type]!,
      'explanation': instance.explanation,
      'hint': instance.hint,
    };

const _$QuizQuestionTypeEnumMap = {
  QuizQuestionType.single: 'single',
  QuizQuestionType.multiple: 'multiple',
};

_Quiz _$QuizFromJson(Map<String, dynamic> json) => _Quiz(
  id: json['id'] as String,
  topic: json['topic'] as String,
  title: json['title'] as String,
  category: json['category'] as String,
  topics: (json['topics'] as List<dynamic>).map((e) => e as String).toList(),
  difficulty: json['difficulty'] as String,
  questions: (json['questions'] as List<dynamic>)
      .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$QuizToJson(_Quiz instance) => <String, dynamic>{
  'id': instance.id,
  'topic': instance.topic,
  'title': instance.title,
  'category': instance.category,
  'topics': instance.topics,
  'difficulty': instance.difficulty,
  'questions': instance.questions,
  'createdAt': instance.createdAt.toIso8601String(),
};
