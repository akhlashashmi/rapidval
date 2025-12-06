import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../auth/data/auth_repository.dart';
import '../data/backup_repository.dart';
import '../domain/backup_snapshot.dart';
import '../../quiz/domain/user_answer.dart' hide QuizResult;

part 'backup_service.g.dart';

class BackupService {
  final AppDatabase _db;
  final BackupRepository _repository;
  final String _userId;

  BackupService(this._db, this._repository, this._userId);

  Future<void> createBackup() async {
    try {
      if (_userId.isEmpty) throw Exception('User not logged in');

      log('BackupService: Creating backup for user $_userId...');

      // 1. Fetch all data filtered by userId
      final quizzes = await (_db.select(
        _db.quizzes,
      )..where((t) => t.userId.equals(_userId))).get();

      // Questions don't have userId directly, but are linked to quizzes.
      // We should fetch questions for the fetched quizzes.
      final quizIds = quizzes.map((q) => q.id).toList();
      final questions = await (_db.select(
        _db.questions,
      )..where((t) => t.quizId.isIn(quizIds))).get();

      final results = await (_db.select(
        _db.quizResults,
      )..where((t) => t.userId.equals(_userId))).get();

      final preferences = await (_db.select(
        _db.userPreferences,
      )..where((t) => t.userId.equals(_userId))).get();

      final progress = await (_db.select(
        _db.quizProgress,
      )..where((t) => t.userId.equals(_userId))).get();

      // 2. Serialize
      final data = {
        'quizzes': quizzes.map((e) => e.toJson()).toList(),
        'questions': questions.map((e) => e.toJson()).toList(),
        'quizResults': results.map((e) {
          final json = e.toJson();
          if (json['answers'] is List) {
            json['answers'] = (json['answers'] as List)
                .map((a) => (a as dynamic).toJson())
                .toList();
          }
          return json;
        }).toList(),
        'userPreferences': preferences.map((e) => e.toJson()).toList(),
        'quizProgress': progress.map((e) {
          final json = e.toJson();
          if (json['answers'] is List) {
            json['answers'] = (json['answers'] as List)
                .map((a) => (a as dynamic).toJson())
                .toList();
          }
          return json;
        }).toList(),
      };

      // 3. Create Snapshot
      final snapshot = BackupSnapshot(
        id: const Uuid().v4(), // Internal ID, doc ID is userId
        userId: _userId,
        createdAt: DateTime.now(),
        version: 1,
        data: data,
        metadata: BackupMetadata(
          quizCount: quizzes.length,
          questionCount: questions.length,
          resultCount: results.length,
          deviceName: 'Unknown', // TODO: Get real device name
          appVersion: '1.0.0', // TODO: Get real app version
        ),
      );

      // 4. Upload (Overwrite)
      await _repository.saveBackup(snapshot);
      log('BackupService: Backup created successfully');
    } catch (e, s) {
      log('BackupService: Error creating backup', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> restoreBackup({bool merge = true}) async {
    try {
      if (_userId.isEmpty) throw Exception('User not logged in');

      log('BackupService: Restoring backup (merge=$merge)...');

      final backup = await _repository.getBackup(_userId);
      if (backup == null) throw Exception('No backup found');

      if (merge) {
        await _mergeBackup(backup);
      } else {
        await _replaceBackup(backup);
      }
      log('BackupService: Restore complete');
    } catch (e, s) {
      log('BackupService: Error restoring backup', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> _replaceBackup(BackupSnapshot backup) async {
    await _db.transaction(() async {
      // 1. Clear all tables for this user
      // Note: Deleting quizzes cascades to questions, results, progress usually.
      // But we should be careful to only delete THIS user's data.

      await (_db.delete(
        _db.quizzes,
      )..where((t) => t.userId.equals(_userId))).go();
      await (_db.delete(
        _db.userPreferences,
      )..where((t) => t.userId.equals(_userId))).go();
      // Questions are deleted via cascade from quizzes usually, but let's be safe if we can.
      // Questions table doesn't have userId. Rely on cascade or manual cleanup if needed.
      // Assuming cascade is set up in AppDatabase (onDelete: KeyAction.cascade).

      // QuizResults and QuizProgress have userId.
      await (_db.delete(
        _db.quizResults,
      )..where((t) => t.userId.equals(_userId))).go();
      await (_db.delete(
        _db.quizProgress,
      )..where((t) => t.userId.equals(_userId))).go();

      // 2. Insert Data
      await _insertData(backup.data);
    });
  }

  Future<void> _mergeBackup(BackupSnapshot backup) async {
    await _db.transaction(() async {
      final data = backup.data;

      // 1. Quizzes & Questions
      final quizzesJson = data['quizzes'] ?? [];
      final questionsJson = data['questions'] ?? [];

      for (final quizMap in quizzesJson) {
        final sanitizedQuiz = Map<String, dynamic>.from(quizMap);

        // Defaults for Quizzes
        sanitizedQuiz['userId'] ??= _userId;
        sanitizedQuiz['title'] ??= '';
        sanitizedQuiz['category'] ??= 'General Knowledge';
        sanitizedQuiz['topics'] ??= [];

        if (sanitizedQuiz['topics'] is List) {
          sanitizedQuiz['topics'] = (sanitizedQuiz['topics'] as List)
              .cast<String>();
        } else {
          sanitizedQuiz['topics'] = <String>[];
        }

        final quiz = Quizze.fromJson(sanitizedQuiz);

        // Check if exists
        final exists = await (_db.select(
          _db.quizzes,
        )..where((t) => t.id.equals(quiz.id))).getSingleOrNull();

        if (exists == null) {
          // Insert new quiz
          await _db.into(_db.quizzes).insert(quiz);

          // Insert associated questions
          await _insertQuestionsForQuiz(questionsJson, quiz.id);
        } else {
          // Conflict: Quiz exists. Overwrite with backup.
          await _db.update(_db.quizzes).replace(quiz);

          // Replace questions
          await (_db.delete(
            _db.questions,
          )..where((t) => t.quizId.equals(quiz.id))).go();

          await _insertQuestionsForQuiz(questionsJson, quiz.id);
        }
      }

      // 2. Quiz Results
      final resultsJson = data['quizResults'] ?? [];
      for (final resultMap in resultsJson) {
        final sanitized = Map<String, dynamic>.from(resultMap);
        sanitized['userId'] ??= _userId;

        if (sanitized['answers'] is List) {
          sanitized['answers'] = (sanitized['answers'] as List)
              .map((e) => UserAnswer.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        final result = QuizResult.fromJson(sanitized);
        await _db.into(_db.quizResults).insertOnConflictUpdate(result);
      }

      // 3. User Preferences
      final prefsJson = data['userPreferences'] ?? [];
      for (final prefMap in prefsJson) {
        final sanitized = Map<String, dynamic>.from(prefMap);
        sanitized['userId'] ??= _userId;
        final pref = UserPreference.fromJson(sanitized);
        await _db.into(_db.userPreferences).insertOnConflictUpdate(pref);
      }

      // 4. Quiz Progress
      final progressJson = data['quizProgress'] ?? [];
      for (final progMap in progressJson) {
        final sanitized = Map<String, dynamic>.from(progMap);
        sanitized['userId'] ??= _userId;
        sanitized['timePerQuestion'] ??= 15;

        if (sanitized['answers'] is List) {
          sanitized['answers'] = (sanitized['answers'] as List)
              .map((e) => UserAnswer.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        final prog = QuizProgressData.fromJson(sanitized);

        final localProg =
            await (_db.select(_db.quizProgress)..where(
                  (t) =>
                      t.userId.equals(prog.userId) &
                      t.quizId.equals(prog.quizId),
                ))
                .getSingleOrNull();

        if (localProg == null) {
          await _db.into(_db.quizProgress).insert(prog);
        } else {
          // Compare timestamps
          if (prog.lastUpdated.isAfter(localProg.lastUpdated)) {
            await _db.update(_db.quizProgress).replace(prog);
          }
        }
      }
    });
  }

  Future<void> _insertQuestionsForQuiz(
    List<dynamic> allQuestions,
    String quizId,
  ) async {
    final quizQuestions = allQuestions.where((q) => q['quizId'] == quizId).map((
      q,
    ) {
      final sanitizedQ = Map<String, dynamic>.from(q);

      // Defaults for Questions
      sanitizedQ['type'] ??= 'single';
      sanitizedQ['correctIndices'] ??= [];
      sanitizedQ['hint'] ??= null;
      if (sanitizedQ['options'] is List) {
        sanitizedQ['options'] = (sanitizedQ['options'] as List).cast<String>();
      } else {
        sanitizedQ['options'] = <String>[];
      }

      if (sanitizedQ['correctIndices'] is List) {
        sanitizedQ['correctIndices'] = (sanitizedQ['correctIndices'] as List)
            .cast<int>()
            .toList();
      } else {
        sanitizedQ['correctIndices'] = <int>[];
      }

      return Question.fromJson(sanitizedQ);
    });

    for (final q in quizQuestions) {
      await _db.into(_db.questions).insert(q);
    }
  }

  Future<void> _insertData(Map<String, List<Map<String, dynamic>>> data) async {
    final quizzesJson = data['quizzes'] ?? [];
    for (final m in quizzesJson) {
      final sanitized = Map<String, dynamic>.from(m);

      sanitized['userId'] ??= _userId;
      sanitized['title'] ??= '';
      sanitized['category'] ??= 'General Knowledge';
      sanitized['topics'] ??= [];

      if (sanitized['topics'] is List) {
        sanitized['topics'] = (sanitized['topics'] as List).cast<String>();
      } else {
        sanitized['topics'] = <String>[];
      }
      await _db
          .into(_db.quizzes)
          .insert(Quizze.fromJson(sanitized), mode: InsertMode.insertOrReplace);
    }

    final questionsJson = data['questions'] ?? [];
    for (final m in questionsJson) {
      final sanitized = Map<String, dynamic>.from(m);

      sanitized['type'] ??= 'single';
      sanitized['correctIndices'] ??= [];
      sanitized['hint'] ??= null;

      if (sanitized['options'] is List) {
        sanitized['options'] = (sanitized['options'] as List).cast<String>();
      } else {
        sanitized['options'] = <String>[];
      }

      if (sanitized['correctIndices'] is List) {
        sanitized['correctIndices'] = (sanitized['correctIndices'] as List)
            .cast<int>()
            .toList();
      } else {
        sanitized['correctIndices'] = <int>[];
      }

      await _db
          .into(_db.questions)
          .insert(
            Question.fromJson(sanitized),
            mode: InsertMode.insertOrReplace,
          );
    }
    final resultsJson = data['quizResults'] ?? [];
    for (final m in resultsJson) {
      final sanitized = Map<String, dynamic>.from(m);
      sanitized['userId'] ??= _userId;

      if (sanitized['answers'] is List) {
        sanitized['answers'] = (sanitized['answers'] as List)
            .map((e) => UserAnswer.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      await _db
          .into(_db.quizResults)
          .insert(
            QuizResult.fromJson(sanitized),
            mode: InsertMode.insertOrReplace,
          );
    }

    final prefsJson = data['userPreferences'] ?? [];
    for (final m in prefsJson) {
      final sanitized = Map<String, dynamic>.from(m);
      sanitized['userId'] ??= _userId;
      await _db
          .into(_db.userPreferences)
          .insert(
            UserPreference.fromJson(sanitized),
            mode: InsertMode.insertOrReplace,
          );
    }

    final progressJson = data['quizProgress'] ?? [];
    for (final m in progressJson) {
      final sanitized = Map<String, dynamic>.from(m);
      sanitized['userId'] ??= _userId;
      sanitized['timePerQuestion'] ??= 15;

      if (sanitized['answers'] is List) {
        sanitized['answers'] = (sanitized['answers'] as List)
            .map((e) => UserAnswer.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      await _db
          .into(_db.quizProgress)
          .insert(
            QuizProgressData.fromJson(sanitized),
            mode: InsertMode.insertOrReplace,
          );
    }
  }
}

@riverpod
BackupService backupService(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final repository = ref.watch(backupRepositoryProvider);
  final auth = ref.watch(authRepositoryProvider);
  return BackupService(db, repository, auth.currentUser?.uid ?? '');
}
