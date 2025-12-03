import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/app_database.dart' as db;
import '../../../core/database/database_provider.dart';
import '../../dashboard/domain/quiz_config.dart';
import '../../quiz/domain/quiz_entity.dart';
import '../../quiz/domain/user_answer.dart';
import '../../../core/services/gemini_service.dart';
import '../../auth/data/auth_repository.dart';
import '../../quiz/presentation/quiz_state.dart';

part 'quiz_repository.g.dart';

class QuizRepository {
  final GeminiService _geminiService;
  final db.AppDatabase _db;
  final AuthRepository _authRepository;

  QuizRepository(this._geminiService, this._db, this._authRepository);

  Future<Quiz> generateQuiz(QuizConfig config) async {
    debugPrint(
      'QuizRepository: generateQuiz called for topic: ${config.topic}',
    );
    try {
      final quiz = await _geminiService.generateQuiz(config);
      debugPrint('QuizRepository: Quiz generated: ${quiz.id}');
      await _saveQuizToDb(quiz);
      return quiz;
    } catch (e) {
      debugPrint('QuizRepository: generateQuiz error: $e');
      rethrow;
    }
  }

  Stream<(double progress, Quiz? quiz)> generateQuizStream(
    QuizConfig config,
  ) async* {
    debugPrint(
      'QuizRepository: generateQuizStream called for topic: ${config.topic}',
    );
    try {
      await for (final event in _geminiService.generateQuizStream(config)) {
        if (event.$2 != null) {
          debugPrint(
            'QuizRepository: Quiz generated via stream: ${event.$2!.id}',
          );
          await _saveQuizToDb(event.$2!);
        }
        yield event;
      }
    } catch (e) {
      debugPrint('QuizRepository: generateQuizStream error: $e');
      rethrow;
    }
  }

  Future<void> _saveQuizToDb(Quiz quiz) async {
    debugPrint('QuizRepository: _saveQuizToDb called for ${quiz.id}');
    final userId = _authRepository.currentUser?.uid ?? '';
    await _db.transaction(() async {
      await _db
          .into(_db.quizzes)
          .insert(
            db.QuizzesCompanion.insert(
              id: quiz.id,
              userId: Value(userId),
              topic: quiz.topic,
              title: Value(quiz.title),
              category: Value(quiz.category),
              topics: Value(quiz.topics),
              difficulty: quiz.difficulty,
              createdAt: quiz.createdAt,
            ),
          );

      for (final question in quiz.questions) {
        await _db
            .into(_db.questions)
            .insert(
              db.QuestionsCompanion.insert(
                id: question.id,
                quizId: quiz.id,
                question: question.question,
                options: question.options,
                correctOptionIndex: question.correctOptionIndex,
                explanation: question.explanation,
                hint: Value(question.hint),
              ),
            );
      }
    });
    debugPrint('QuizRepository: _saveQuizToDb success');
  }

  Future<void> saveQuizResult(QuizResult result) async {
    debugPrint('QuizRepository: saveQuizResult called for ${result.quizId}');
    final userId = _authRepository.currentUser?.uid ?? '';

    // Check if a result already exists for this quiz and user
    final existingResult =
        await (_db.select(_db.quizResults)
              ..where(
                (t) => t.userId.equals(userId) & t.quizId.equals(result.quizId),
              )
              ..limit(1))
            .getSingleOrNull();

    if (existingResult != null) {
      // Only update if the new score is higher
      if (result.percentage > existingResult.percentage) {
        debugPrint('QuizRepository: New high score! Updating result.');
        await (_db.update(
          _db.quizResults,
        )..where((t) => t.id.equals(existingResult.id))).write(
          db.QuizResultsCompanion(
            score: Value(result.correctAnswers),
            totalQuestions: Value(result.totalQuestions),
            percentage: Value(result.percentage),
            completedAt: Value(result.completedAt),
            answers: Value(result.answers),
          ),
        );
      } else {
        debugPrint(
          'QuizRepository: Score not higher. Keeping existing result.',
        );
      }
    } else {
      // Insert new result
      await _db
          .into(_db.quizResults)
          .insert(
            db.QuizResultsCompanion.insert(
              id: DateTime.now().toIso8601String(), // Simple ID generation
              userId: Value(userId),
              quizId: result.quizId,
              score: result.correctAnswers,
              totalQuestions: result.totalQuestions,
              percentage: result.percentage,
              completedAt: result.completedAt,
              answers: result.answers,
            ),
          );
    }
    debugPrint('QuizRepository: saveQuizResult success');
  }

  Future<List<QuizResult>> getRecentResults({int limit = 5}) async {
    debugPrint('QuizRepository: getRecentResults called');
    final userId = _authRepository.currentUser?.uid ?? '';
    final query = _db.select(_db.quizResults)
      ..where((t) => t.userId.equals(userId))
      ..orderBy([
        (t) => drift.OrderingTerm(
          expression: t.completedAt,
          mode: drift.OrderingMode.desc,
        ),
      ])
      ..limit(limit);

    final results = await query.get();

    final List<QuizResult> domainResults = [];

    for (final row in results) {
      final quiz = await _getQuizById(row.quizId);
      if (quiz != null) {
        domainResults.add(
          QuizResult(
            quizId: row.quizId,
            quiz: quiz,
            answers: row.answers,
            startedAt: row.completedAt.subtract(
              const Duration(minutes: 5),
            ), // Approximate
            completedAt: row.completedAt,
            correctAnswers: row.score,
            totalQuestions: row.totalQuestions,
            percentage: row.percentage,
          ),
        );
      }
    }

    debugPrint(
      'QuizRepository: getRecentResults found ${domainResults.length} results',
    );
    return domainResults;
  }

  Future<List<QuizResult>> getAllResults() async {
    debugPrint('QuizRepository: getAllResults called');
    final userId = _authRepository.currentUser?.uid ?? '';
    final query = _db.select(_db.quizResults)
      ..where((t) => t.userId.equals(userId))
      ..orderBy([
        (t) => drift.OrderingTerm(
          expression: t.completedAt,
          mode: drift.OrderingMode.desc,
        ),
      ]);

    final results = await query.get();

    final List<QuizResult> domainResults = [];

    for (final row in results) {
      final quiz = await _getQuizById(row.quizId);
      if (quiz != null) {
        domainResults.add(
          QuizResult(
            quizId: row.quizId,
            quiz: quiz,
            answers: row.answers,
            startedAt: row.completedAt.subtract(
              const Duration(minutes: 5),
            ), // Approximate
            completedAt: row.completedAt,
            correctAnswers: row.score,
            totalQuestions: row.totalQuestions,
            percentage: row.percentage,
          ),
        );
      }
    }

    debugPrint(
      'QuizRepository: getAllResults found ${domainResults.length} results',
    );
    return domainResults;
  }

  Future<void> saveQuizProgress(QuizState state, int timePerQuestion) async {
    debugPrint('QuizRepository: saveQuizProgress called for ${state.quiz.id}');
    final userId = _authRepository.currentUser?.uid ?? '';
    await _db
        .into(_db.quizProgress)
        .insertOnConflictUpdate(
          db.QuizProgressCompanion.insert(
            userId: userId,
            quizId: state.quiz.id,
            currentQuestionIndex: state.currentQuestionIndex,
            timeLeft: state.timeLeft,
            timePerQuestion: Value(timePerQuestion),
            answers: state.userAnswers,
            startedAt: state.startedAt,
            lastUpdated: Value(DateTime.now()),
          ),
        );
    debugPrint('QuizRepository: saveQuizProgress success');
  }

  Future<(QuizState, int)?> getQuizProgress() async {
    debugPrint('QuizRepository: getQuizProgress called');
    final userId = _authRepository.currentUser?.uid ?? '';
    final progress =
        await (_db.select(_db.quizProgress)
              ..where((t) => t.userId.equals(userId))
              ..orderBy([
                (t) => drift.OrderingTerm(
                  expression: t.lastUpdated,
                  mode: drift.OrderingMode.desc,
                ),
              ])
              ..limit(1))
            .getSingleOrNull();

    if (progress == null) {
      debugPrint('QuizRepository: getQuizProgress - no progress found');
      return null;
    }

    final quiz = await _getQuizById(progress.quizId);
    if (quiz == null) {
      debugPrint(
        'QuizRepository: getQuizProgress - quiz not found for progress',
      );
      return null;
    }

    final state = QuizState(
      quiz: quiz,
      currentQuestionIndex: progress.currentQuestionIndex,
      timeLeft: progress.timeLeft,
      userAnswers: progress.answers,
      startedAt: progress.startedAt,
    );

    debugPrint('QuizRepository: getQuizProgress success');
    return (state, progress.timePerQuestion);
  }

  Future<void> clearQuizProgress(String quizId) async {
    debugPrint('QuizRepository: clearQuizProgress called for $quizId');
    final userId = _authRepository.currentUser?.uid ?? '';
    await (_db.delete(
      _db.quizProgress,
    )..where((t) => t.userId.equals(userId) & t.quizId.equals(quizId))).go();
    debugPrint('QuizRepository: clearQuizProgress success');
  }

  Future<Quiz?> _getQuizById(String id) async {
    final quizRow = await (_db.select(
      _db.quizzes,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (quizRow == null) return null;

    final questionsRows = await (_db.select(
      _db.questions,
    )..where((t) => t.quizId.equals(id))).get();

    final questions = questionsRows
        .map(
          (row) => QuizQuestion(
            id: row.id,
            question: row.question,
            options: row.options,
            correctOptionIndex: row.correctOptionIndex,
            explanation: row.explanation,
            hint: row.hint,
          ),
        )
        .toList();

    return Quiz(
      id: quizRow.id,
      topic: quizRow.topic,
      title: quizRow.title,
      category: quizRow.category,
      topics: quizRow.topics,
      difficulty: quizRow.difficulty,
      questions: questions,
      createdAt: quizRow.createdAt,
    );
  }
}

@Riverpod(keepAlive: true)
QuizRepository quizRepository(Ref ref) {
  final geminiService = ref.watch(geminiServiceProvider);
  final db = ref.watch(appDatabaseProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return QuizRepository(geminiService, db, authRepository);
}

@riverpod
Future<List<QuizResult>> recentQuizResults(Ref ref) {
  return ref.watch(quizRepositoryProvider).getRecentResults();
}

@riverpod
Future<List<QuizResult>> allQuizResults(Ref ref) {
  return ref.watch(quizRepositoryProvider).getAllResults();
}

@riverpod
Future<(QuizState, int)?> activeQuizProgress(Ref ref) {
  return ref.watch(quizRepositoryProvider).getQuizProgress();
}
