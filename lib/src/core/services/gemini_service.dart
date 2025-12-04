import 'dart:convert';
import 'dart:async';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:rapidval/src/features/quiz/domain/quiz_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/dashboard/domain/quiz_config.dart';
import '../../features/quiz/domain/quiz_entity.dart';
import 'package:uuid/uuid.dart';

part 'gemini_service.g.dart';

class GeminiService {
  final GenerativeModel _model;
  final _uuid = const Uuid();

  GeminiService()
    : _model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash-lite',
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
      );

  Future<Quiz> generateQuiz(QuizConfig config) async {
    if (_isInappropriate(config.topic)) {
      throw Exception('Topic is not suitable for a quiz.');
    }

    final prompt = _buildPrompt(config);
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);

    if (response.text == null) {
      throw Exception('Failed to generate quiz content.');
    }

    return _parseQuiz(response.text!, config);
  }

  Stream<(double progress, Quiz? quiz)> generateQuizStream(
    QuizConfig config,
  ) async* {
    if (_isInappropriate(config.topic)) {
      throw Exception('Topic is not suitable for a quiz.');
    }

    final prompt = _buildPrompt(config);
    final content = [Content.text(prompt)];
    final buffer = StringBuffer();

    final stream = _model.generateContentStream(content);

    await for (final chunk in stream) {
      if (chunk.text != null) {
        buffer.write(chunk.text);
        final currentText = buffer.toString();

        // Estimate progress based on "question" keys found
        // We look for "question": or "question" :
        final matches = RegExp(
          r'"question"\s*:',
        ).allMatches(currentText).length;

        // Calculate progress, capping at 90% until final completion
        // We assume we might find 'question' count equal to config.questionCount
        double progress = 0.0;
        if (config.questionCount > 0) {
          progress = (matches / config.questionCount).clamp(0.0, 0.9);
        }

        yield (progress, null);
      }
    }

    try {
      final quiz = _parseQuiz(buffer.toString(), config);
      yield (1.0, quiz);
    } catch (e) {
      throw Exception('Failed to parse generated quiz: $e');
    }
  }

  Quiz _parseQuiz(String jsonString, QuizConfig config) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final questions = (json['questions'] as List).map((q) {
        return QuizQuestion(
          id: _uuid.v4(),
          question: q['question'],
          options: List<String>.from(q['options']),
          correctOptionIndex: q['correctOptionIndex'],
          explanation: q['explanation'],
          hint: q['hint'],
        );
      }).toList();

      return Quiz(
        id: _uuid.v4(),
        topic: config.topic,
        title: json['quizTitle'] ?? config.topic,
        category: json['category'] ?? 'General Knowledge',
        topics: List<String>.from(json['topics'] ?? []),
        difficulty: config.difficulty.name,
        questions: questions,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to parse quiz: $e');
    }
  }

  bool _isInappropriate(String topic) {
    final blockedKeywords = ['violence', 'hate', 'nsfw', 'sex', 'drugs'];
    final lowerTopic = topic.toLowerCase();
    return blockedKeywords.any((word) => lowerTopic.contains(word));
  }

  String _buildPrompt(QuizConfig config) {
    // 2. Get the list of categories dynamically from the Enum
    final categoriesList = QuizCategory.allCategoriesPromptString;

    return '''
  You are an expert quiz generator for a mobile app. Generate a quiz based on the user input: "${config.topic}".
  
  Configuration:
  - Difficulty: ${config.difficulty.name}
  - Number of questions: ${config.questionCount}
  
  Step 1: Classify the topic into EXACTLY one of these ${QuizCategory.values.length} categories:
  [$categoriesList]

  Step 2: Generate a list of exactly 5 related "topics". These will be used for similarity matching. They should range from specific to general.
  
  Return ONLY a valid JSON object with this specific schema:
  {
    "quizTitle": "A very concise, engaging title for the quiz",
    "category": "The selected category from the list above",
    "topics": ["Keyword1", "Keyword2", ..],
    "difficulty": "${config.difficulty.name}",
    "questions": [
      {
        "question": "The question text",
        "options": ["Option A", "Option B", "Option C", "Option D"],
        "correctOptionIndex": 0, // Integer 0-3
        "hint": "A subtle clue that helps without giving the answer",
        "explanation": "Detailed explanation of the correct answer"
      }
    ]
  }
  
  Ensure the JSON is valid and strictly follows the schema. Do not include markdown formatting.
  ''';
  }
}

@Riverpod(keepAlive: true)
GeminiService geminiService(Ref ref) {
  return GeminiService();
}
