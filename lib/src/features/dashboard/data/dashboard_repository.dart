import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../auth/data/auth_repository.dart';
import '../../dashboard/domain/quiz_config.dart';

part 'dashboard_repository.g.dart';

class DashboardRepository {
  final AppDatabase _db;
  final AuthRepository _authRepository;

  DashboardRepository(this._db, this._authRepository);

  Future<void> savePreferences(QuizConfig config) async {
    debugPrint(
      'DashboardRepository: savePreferences called for topic: ${config.topic}',
    );
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) {
      debugPrint('DashboardRepository: savePreferences - no user logged in');
      return;
    }

    try {
      await _db
          .into(_db.userPreferences)
          .insertOnConflictUpdate(
            UserPreferencesCompanion.insert(
              userId: userId,
              lastTopic: Value(config.topic),
              difficulty: Value(config.difficulty.name),
              questionCount: Value(config.questionCount),
              timePerQuestion: Value(config.timePerQuestionSeconds),
            ),
          );
      debugPrint('DashboardRepository: savePreferences success');
    } catch (e) {
      debugPrint('DashboardRepository: savePreferences error: $e');
      rethrow;
    }
  }

  Future<QuizConfig?> loadPreferences() async {
    debugPrint('DashboardRepository: loadPreferences called');
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) {
      debugPrint('DashboardRepository: loadPreferences - no user logged in');
      return null;
    }

    try {
      final prefs = await (_db.select(
        _db.userPreferences,
      )..where((t) => t.userId.equals(userId))).getSingleOrNull();

      if (prefs == null) {
        debugPrint('DashboardRepository: loadPreferences - no prefs found');
        return null;
      }

      debugPrint('DashboardRepository: loadPreferences success');
      return QuizConfig(
        topic: prefs.lastTopic ?? '',
        difficulty: QuizDifficulty.values.firstWhere(
          (e) => e.name == prefs.difficulty,
          orElse: () => QuizDifficulty.intermediate,
        ),
        questionCount: prefs.questionCount ?? 5,
        timePerQuestionSeconds: prefs.timePerQuestion ?? 15,
      );
    } catch (e) {
      debugPrint('DashboardRepository: loadPreferences error: $e');
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
DashboardRepository dashboardRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return DashboardRepository(db, authRepository);
}
